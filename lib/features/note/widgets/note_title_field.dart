import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
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
