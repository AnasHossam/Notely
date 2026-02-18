import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

import 'package:notely/features/home/widgets/note_preview_content.dart';
import 'package:notely/features/note/domain/note_entity.dart';

class HomeNoteWidget extends ConsumerWidget {
  const HomeNoteWidget({
    super.key,
    required this.note,
    this.highlightTerm,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onTap,
    this.onLongPress,
  });

  final NoteEntity note;
  final String? highlightTerm;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkTheme(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(20),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primaryDarkColor.withValues(alpha: 0.2)
                  : AppColors.primaryLightColor.withValues(alpha: 0.1))
              : (isDark ? AppColors.noteDarkColor : AppColors.noteLightColor),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 2 : 1,
              color: isSelected
                  ? (isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryLightColor)
                  : (isDark
                      ? AppColors.borderDarkColor
                      : AppColors.borderLightColor),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: [
            BoxShadow(
              color: const Color(0x111F2687),
              blurRadius: 32,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.tag != null && note.tag!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryLightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(note.tag!,
                    style: Theme.of(context).textTheme.labelSmall),
              ),
              const SizedBox(height: 8),
            ],
            _buildHighlightedTitle(context, note.title, highlightTerm),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ClipRect(
                child: NotePreviewContent(
                  contentJson: note.content,
                  maxLines: 10,
                  highlightTerm: highlightTerm,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedTitle(
      BuildContext context, String title, String? term) {
    final style = Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        );

    if (term == null || term.isEmpty) {
      return Text(title,
          style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final lowerTitle = title.toLowerCase();
    final lowerTerm = term.toLowerCase();

    if (!lowerTitle.contains(lowerTerm)) {
      return Text(title,
          style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final children = <InlineSpan>[];
    int currentIndex = 0;

    while (true) {
      final matchIndex = lowerTitle.indexOf(lowerTerm, currentIndex);
      if (matchIndex == -1) {
        children
            .add(TextSpan(text: title.substring(currentIndex), style: style));
        break;
      }

      if (matchIndex > currentIndex) {
        children.add(TextSpan(
            text: title.substring(currentIndex, matchIndex), style: style));
      }

      final matchText = title.substring(matchIndex, matchIndex + term.length);
      children.add(TextSpan(
          text: matchText,
          style: style.copyWith(
            backgroundColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.3),
            color: Theme.of(context).primaryColor,
          )));

      currentIndex = matchIndex + term.length;
    }

    return RichText(
      text: TextSpan(children: children),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
