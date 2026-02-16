import 'package:flutter/material.dart';
import 'package:notely/features/home/widgets/home_app_bar.dart';
import 'package:notely/features/home/widgets/home_floating_action_button.dart';
import 'package:notely/features/home/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(child: HomeViewBody()),
      floatingActionButton: HomeFloatingActionButton(),
    );
  }
}
