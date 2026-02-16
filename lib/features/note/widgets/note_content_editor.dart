import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notely/features/note/widgets/image_embed_builder.dart';

class NoteContentEditor extends StatelessWidget {
  const NoteContentEditor({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final QuillController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Theme.of(context).primaryColor,
          selectionColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
          selectionHandleColor: Theme.of(context).primaryColor,
        ),
      ),
      child: QuillEditor.basic(
        controller: controller,
        focusNode: focusNode,
        config: QuillEditorConfig(
          placeholder: 'Start writing...',
          scrollable: false,
          autoFocus: false,
          expands: false,
          padding: EdgeInsets.zero,
          embedBuilders: [
            ImageEmbedBuilder(),
          ],
        ),
      ),
    );
  }
}
