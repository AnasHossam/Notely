import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class NoteDateAndTagsHeader extends StatelessWidget {
  const NoteDateAndTagsHeader(
      {super.key, required this.date, required this.tag});

  final String date;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: isDarkTheme(context)
                ? AppColors.primaryDarkColor
                : AppColors.primaryLightColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
