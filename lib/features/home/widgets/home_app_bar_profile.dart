import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';

class HomeAppBarProfile extends StatelessWidget {
  const HomeAppBarProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme(context)
              ? AppColors.primaryDarkColor
              : AppColors.primaryLightColor,
          width: 2,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage("assets/images/Anas Hossam.jpg"),
        ),
      ),
    );
  }
}
