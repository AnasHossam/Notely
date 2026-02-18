import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/home/widgets/home_section_container.dart';

class HomeSectionsList extends ConsumerWidget {
  const HomeSectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(homeTagsProvider);
    final currentTag = ref.watch(currentTagProvider);

    return SizedBox(
      height: 50,
      child: tagsAsync.when(
        data: (tags) {
          final allOptions = ['All Notes', ...tags];
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allOptions.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final label = allOptions[index];
              final isAll = index == 0;
              final tagToSelect = isAll ? null : label;
              final isSelected =
                  isAll ? currentTag == null : currentTag == label;

              return GestureDetector(
                onTap: () {
                  ref.read(currentTagProvider.notifier).set(tagToSelect);
                },
                child: HomeSectionContainer(
                  label: label,
                  isSelected: isSelected,
                ),
              );
            },
          );
        },
        error: (e, s) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
