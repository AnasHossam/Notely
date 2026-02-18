import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/core/helpers/date_and_time.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/managers/note_detail_manager.dart';
import 'package:notely/features/note/widgets/note_content_editor.dart';
import 'package:notely/features/note/widgets/note_date_and_tags_header.dart';
import 'package:notely/features/note/widgets/note_title_field.dart';
import 'package:notely/features/note/widgets/note_toolbar.dart';
import 'package:uuid/uuid.dart';

class NoteViewBody extends ConsumerStatefulWidget {
  const NoteViewBody({super.key, this.note, this.searchTerm});

  final NoteEntity? note;
  final String? searchTerm;

  @override
  ConsumerState<NoteViewBody> createState() => _NoteViewBodyState();
}

class _NoteViewBodyState extends ConsumerState<NoteViewBody> {
  late final QuillController _controller;
  late final TextEditingController _titleController;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  bool _showTopToolbar = false;
  bool _isHoveringToolbar = false;
  bool _isPickingImage = false;

  late String _noteId;
  late DateTime _createdAt;
  late DateTime _lastEditedAt;
  String? _tag;
  late NoteDetailManager _noteDetailManager;
  late CurrentNoteNotifier _currentNoteNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _noteDetailManager = ref.read(noteDetailManagerProvider(_noteId).notifier);
    _currentNoteNotifier = ref.read(currentNoteProvider.notifier);
  }

  @override
  void initState() {
    super.initState();
    _initializeNote();
    _editorFocusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleEditorChange);
    _titleController.addListener(_handleTitleChange);

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        if (!visible && _editorFocusNode.hasFocus) {
          _editorFocusNode.unfocus();
        }
        if (visible) {
          if (mounted) {
            setState(() {
              _showTopToolbar = false;
            });
            _scrollToCursor();
          }
        }
      });
    }
  }

  void _initializeNote() {
    if (widget.note != null) {
      _noteId = widget.note!.id;
      _createdAt = widget.note!.createdAt;
      _lastEditedAt = widget.note!.updatedAt;
      _tag = widget.note!.tag;
      _titleController = TextEditingController(text: widget.note!.title);
      try {
        _controller = QuillController(
          document: Document.fromJson(jsonDecode(widget.note!.content)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _controller = QuillController.basic();
      }
      // Initialize provider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(currentNoteProvider.notifier).set(widget.note);
        }
      });
    } else {
      _noteId = const Uuid().v4();
      _createdAt = DateTime.now();
      _lastEditedAt = DateTime.now();
      _tag = null;
      _titleController = TextEditingController();
      _controller = QuillController.basic();
      // Initialize provider as null
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(currentNoteProvider.notifier).set(null);
        }
      });
    }

    // Scroll to search term if present
    if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final plainText = _controller.document.toPlainText();
        final index =
            plainText.toLowerCase().indexOf(widget.searchTerm!.toLowerCase());

        if (index != -1) {
          _controller.updateSelection(
            TextSelection(
              baseOffset: index,
              extentOffset: index + widget.searchTerm!.length,
            ),
            ChangeSource.local,
          );
          _editorFocusNode.requestFocus();
        }
      });
    }
  }

  void _handleTitleChange() {
    _saveNote();
  }

  void _handleEditorChange() {
    if (_editorFocusNode.hasFocus &&
        _controller.selection.baseOffset >= _controller.document.length - 2) {
      _scrollToCursor();
    }
    _saveNote();
  }

  Future<void> _saveNote({bool immediate = false}) async {
    if (!mounted && !immediate) return;

    final content = jsonEncode(_controller.document.toDelta().toJson());
    final title = _titleController.text.trim();

    if (title.isEmpty && _controller.document.isEmpty()) return;

    final now = DateTime.now();
    if (mounted && !immediate) {
      setState(() {
        _lastEditedAt = now;
      });
    }

    final baseNote = widget.note ??
        NoteEntity(
          id: _noteId,
          title: '',
          content: '',
          createdAt: _createdAt,
          updatedAt: now,
          tag: _tag,
        );

    final note = baseNote.copyWith(
      id: _noteId,
      title: title,
      content: content,
      updatedAt: now,
      tag: _tag,
    );

    if (immediate) {
      await _noteDetailManager.saveImmediately(note);
    } else {
      _noteDetailManager.saveNote(note);
    }
    _currentNoteNotifier.set(note);
  }

  void _handleTagChange(String? newTag) {
    setState(() {
      _tag = newTag;
    });
    _saveNote();
  }

  void _scrollToCursor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleFocusChange() {
    if (_editorFocusNode.hasFocus) {
      if (kIsWeb) {
        setState(() {
          _showTopToolbar = true;
        });
      } else {
        Timer(const Duration(milliseconds: 500), () {
          if (mounted && _editorFocusNode.hasFocus) {
            setState(() {
              _showTopToolbar = true;
            });
          }
        });
      }
    } else {
      Timer(const Duration(milliseconds: 200), () {
        if (mounted &&
            !_editorFocusNode.hasFocus &&
            !_isHoveringToolbar &&
            !_isPickingImage) {
          setState(() {
            _showTopToolbar = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription?.cancel();
    _controller.removeListener(_handleEditorChange);
    _titleController.removeListener(_handleTitleChange);

    _saveNote(immediate: true);

    _controller.dispose();
    _titleController.dispose();
    _editorFocusNode.removeListener(_handleFocusChange);
    _editorFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Column(
          children: [
            (!isKeyboardVisible &&
                    (_editorFocusNode.hasFocus ||
                        _isHoveringToolbar ||
                        _isPickingImage) &&
                    _showTopToolbar)
                ? MouseRegion(
                    onEnter: (_) => _isHoveringToolbar = true,
                    onExit: (_) => _isHoveringToolbar = false,
                    child: NoteToolbar(
                      controller: _controller,
                      isTop: true,
                      onImagePickStart: () => _isPickingImage = true,
                      onImagePickEnd: () {
                        _isPickingImage = false;
                        _editorFocusNode.requestFocus();
                      },
                      onImageInserted: _scrollToCursor,
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!_editorFocusNode.hasFocus) {
                    _editorFocusNode.requestFocus();
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        NoteDateAndTagsHeader(
                          date: dateAndTime(time: _lastEditedAt),
                          tag: _tag,
                          onTagChanged: _handleTagChange,
                        ),
                        const SizedBox(height: 16),
                        NoteTitleField(controller: _titleController),
                        const SizedBox(height: 16),
                        NoteContentEditor(
                          controller: _controller,
                          focusNode: _editorFocusNode,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4 +
                              MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            (isKeyboardVisible && _editorFocusNode.hasFocus)
                ? NoteToolbar(controller: _controller)
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
