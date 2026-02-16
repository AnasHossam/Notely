import 'package:flutter/material.dart';
import 'package:notely/features/note/widgets/note_app_bar.dart';
import 'package:notely/features/note/widgets/note_view_body.dart';

class NoteView extends StatelessWidget {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NoteAppBar(),
      body: NoteViewBody(),
      resizeToAvoidBottomInset: true,
    );
  }
}
