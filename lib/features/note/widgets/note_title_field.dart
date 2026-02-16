import 'package:flutter/material.dart';

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Title",
        hintStyle: Theme.of(context).textTheme.titleLarge,
      ),
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
