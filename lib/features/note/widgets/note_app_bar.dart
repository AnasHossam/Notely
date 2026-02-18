import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/features/note/managers/note_detail_manager.dart';
import 'package:notely/features/note/services/pdf_service.dart';

class NoteAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const NoteAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(currentNoteProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: note == null
                ? null
                : () async {
                    await PdfService().generateAndSharePdf(note);
                  },
            icon: const Icon(Icons.ios_share),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
