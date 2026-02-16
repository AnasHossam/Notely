import 'package:flutter/material.dart';
import 'package:notely/features/home/widgets/home_notes_grid.dart';
import 'package:notely/features/home/widgets/home_sections_list.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        children: [
          HomeSectionsList(),
          Expanded(child: HomeNotesGrid()),
        ],
      ),
    );
  }
}
