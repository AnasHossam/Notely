import 'package:flutter/material.dart';
import 'package:notely/core/helpers/is_dark_theme.dart';
import 'package:notely/core/theme/app_colors.dart';
import 'package:notely/features/note/views/note_view.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteView()),
        );
      },
      backgroundColor: isDarkTheme(context)
          ? AppColors.primaryDarkColor
          : AppColors.primaryLightColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
