import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class HomeNoteWidget extends StatelessWidget {
  const HomeNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkTheme(context);
    return Container(
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: isDark ? AppColors.noteDarkColor : AppColors.noteLightColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color:
                isDark ? AppColors.borderDarkColor : AppColors.borderLightColor,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x111F2687),
            blurRadius: 32,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryDarkColor
                  : AppColors.primaryLightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Codes", style: Theme.of(context).textTheme.labelSmall),
          ),
          Text("Lorem Ipsum", style: Theme.of(context).textTheme.titleMedium),
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been...",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
