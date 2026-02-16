import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notely/features/note/widgets/note_content_editor.dart';
import 'package:notely/features/note/widgets/note_date_and_tags_header.dart';
import 'package:notely/features/note/widgets/note_title_field.dart';
import 'package:notely/features/note/widgets/note_toolbar.dart';

class NoteViewBody extends StatefulWidget {
  const NoteViewBody({super.key});

  @override
  State<NoteViewBody> createState() => _NoteViewBodyState();
}

class _NoteViewBodyState extends State<NoteViewBody> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;
  Timer? _debounceTimer;
  bool _showTopToolbar = false;
  bool _isHoveringToolbar = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _editorFocusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleEditorChange);
    // Listen to keyboard visibility changes to handle manual dismissal on mobile
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

  void _handleEditorChange() {
    if (_editorFocusNode.hasFocus &&
        _controller.selection.baseOffset >= _controller.document.length - 2) {
      _scrollToCursor();
    }
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
      _debounceTimer?.cancel();
      // On Web, show immediately. On mobile, wait to check for keyboard.
      if (kIsWeb) {
        setState(() {
          _showTopToolbar = true;
        });
      } else {
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted && _editorFocusNode.hasFocus) {
            setState(() {
              _showTopToolbar = true;
            });
          }
        });
      }
    } else {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 200), () {
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
    _debounceTimer?.cancel();
    _keyboardVisibilitySubscription?.cancel();
    _controller.removeListener(_handleEditorChange);
    _controller.dispose();
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
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const NoteDateAndTagsHeader(
                        date: "February 1, 2026 . 6:30 PM",
                        tag: "Codes",
                      ),
                      const SizedBox(height: 16),
                      const NoteTitleField(),
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
            (isKeyboardVisible && _editorFocusNode.hasFocus)
                ? NoteToolbar(controller: _controller)
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
