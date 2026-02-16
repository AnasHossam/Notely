import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Title",
        hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: isDarkTheme(context)
                ? AppColors.textSecondaryDarkColor
                : AppColors.textSecondaryLightColor),
      ),
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
