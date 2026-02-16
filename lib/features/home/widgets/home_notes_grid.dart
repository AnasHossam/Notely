import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notely/features/home/widgets/home_note_widget.dart';

class HomeNotesGrid extends StatelessWidget {
  const HomeNotesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 50,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(12),
      itemCount: 10,
      itemBuilder: (context, index) {
        final double topPadding = index == 1 ? 50.0 : 0.0;
        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: const SizedBox(height: 215, child: HomeNoteWidget()),
        );
      },
    );
  }
}
