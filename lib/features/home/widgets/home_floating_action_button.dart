import 'package:flutter/material.dart';
import 'package:notely/core/widgets/custom_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for ConsumerWidget and WidgetRef
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';
import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/home/managers/home_selection_manager.dart';
import 'package:notely/features/note/views/note_view.dart';

class HomeFloatingActionButton extends ConsumerWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(homeSelectionManagerProvider);
    final isSelectionMode = selection.isNotEmpty;
    final isDark = isDarkTheme(context);

    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              title: 'Delete Notes',
              icon: Icons.delete_forever,
              iconColor: Colors.red,
              content: Text(
                'Are you sure you want to delete ${selection.length} notes?',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Delete notes
                    ref
                        .read(homeNoteManagerProvider.notifier)
                        .deleteNotes(selection.toList());
                    // Clear selection
                    ref.read(homeSelectionManagerProvider.notifier).clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.red,
        shape: const CircleBorder(),
        child: const Icon(Icons.delete, color: Colors.white),
      );
    }

    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteView()),
        );
      },
      backgroundColor:
          isDark ? AppColors.primaryDarkColor : AppColors.primaryLightColor,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
