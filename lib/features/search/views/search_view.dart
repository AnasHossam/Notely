import 'package:flutter/material.dart';
import 'package:notely/core/utils/app_images.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/widgets/custom_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/home/widgets/home_note_widget.dart';
import 'package:notely/features/note/views/note_view.dart';
import 'package:notely/features/search/managers/search_manager.dart';
import 'package:notely/features/search/managers/search_selection_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchManagerProvider);
    final searchController = useTextEditingController();
    final selection = ref.watch(searchSelectionManagerProvider);
    final isSelectionMode = selection.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search title or content...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Debounce could be added here
            ref.read(searchQueryProvider.notifier).set(value);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: searchResults.when(
        data: (notes) {
          final query = ref.watch(searchQueryProvider);

          if (query.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isDarkTheme(context)
                        ? Assets.imagesSearchDark
                        : Assets.imagesSearchLight,
                    width: 200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start searching...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isDarkTheme(context)
                        ? Assets.imagesSearchNotFoundDark
                        : Assets.imagesSearchNotFoundLight,
                    width: 200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notes found matching "$query"',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final isSelected = selection.contains(note.id);

              return HomeNoteWidget(
                note: note,
                highlightTerm: ref.watch(searchQueryProvider),
                isSelected: isSelected,
                isSelectionMode: isSelectionMode,
                onTap: () {
                  if (isSelectionMode) {
                    ref
                        .read(searchSelectionManagerProvider.notifier)
                        .toggle(note.id);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteView(
                                note: note,
                                searchTerm: ref.watch(searchQueryProvider),
                              )),
                    );
                  }
                },
                onLongPress: () {
                  ref
                      .read(searchSelectionManagerProvider.notifier)
                      .select(note.id);
                },
              );
            },
          );
        },
        error: (e, s) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: isSelectionMode
          ? FloatingActionButton(
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
                          ref
                              .read(homeNoteManagerProvider.notifier)
                              .deleteNotes(selection.toList());
                          ref
                              .read(searchSelectionManagerProvider.notifier)
                              .clear();
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
            )
          : null,
    );
  }
}
