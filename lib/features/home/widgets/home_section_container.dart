import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class HomeSectionContainer extends StatelessWidget {
  const HomeSectionContainer({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkTheme(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: ShapeDecoration(
            color: isSelected
                ? isDark
                    ? AppColors.primaryDarkColor
                    : AppColors.primaryLightColor
                : isDark
                    ? AppColors.backgroundDarkColor
                    : AppColors.backgroundLightColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: isDark
                    ? AppColors.borderDarkColor
                    : AppColors.borderLightColor,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isDark
                          ? AppColors.textSecondaryDarkColor
                          : AppColors.textPrimaryLightColor,
                ),
          ),
        ),
      ),
    );
  }
}
