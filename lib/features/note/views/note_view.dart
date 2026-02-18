import 'package:flutter/material.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/widgets/note_app_bar.dart';
import 'package:notely/features/note/widgets/note_view_body.dart';

class NoteView extends StatelessWidget {
  const NoteView({super.key, this.note, this.searchTerm});

  final NoteEntity? note;
  final String? searchTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoteAppBar(),
      body: NoteViewBody(note: note, searchTerm: searchTerm),
      resizeToAvoidBottomInset: true,
    );
  }
}
