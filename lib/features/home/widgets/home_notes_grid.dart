import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/utils/app_images.dart';
import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/home/managers/home_selection_manager.dart';
import 'package:notely/features/home/widgets/home_note_widget.dart';
import 'package:notely/features/note/views/note_view.dart';

class HomeNotesGrid extends ConsumerWidget {
  const HomeNotesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(homeNoteManagerProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 200) {
          if (!notesAsync.isLoading && !notesAsync.isRefreshing) {
            ref.read(homeNoteManagerProvider.notifier).loadMore();
          }
        }
        return false;
      },
      child: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      isDarkTheme(context)
                          ? Assets.imagesHomeDark
                          : Assets.imagesHomeLight,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No notes yet.\nTap + to create one!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final selection = ref.watch(homeSelectionManagerProvider);
              final isSelected = selection.contains(note.id);
              final isSelectionMode = selection.isNotEmpty;

              return HomeNoteWidget(
                note: note,
                isSelected: isSelected,
                isSelectionMode: isSelectionMode,
                onTap: () {
                  if (isSelectionMode) {
                    ref
                        .read(homeSelectionManagerProvider.notifier)
                        .toggle(note.id);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteView(note: note)),
                    );
                  }
                },
                onLongPress: () {
                  ref
                      .read(homeSelectionManagerProvider.notifier)
                      .select(note.id);
                },
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
