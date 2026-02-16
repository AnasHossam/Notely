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

  @override
  void initState() {
    super.initState();
    _editorFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
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
                Expanded(
                  child: NoteContentEditor(
                    controller: _controller,
                    focusNode: _editorFocusNode,
                  ),
                ),
              ],
            ),
          ),
        ),
        KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return isKeyboardVisible && _editorFocusNode.hasFocus
                ? NoteToolbar(controller: _controller)
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
