import 'package:flutter/material.dart';
import 'package:notely/features/home/widgets/home_section_container.dart';

class HomeSectionsList extends StatelessWidget {
  const HomeSectionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: HomeSectionContainer(isSelected: index == 0),
          );
        },
      ),
    );
  }
}
