import 'package:flutter/material.dart';
import 'package:notely/features/home/widgets/home_app_bar_profile.dart';
import 'package:notely/features/search/views/search_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/features/profile/managers/user_profile_manager.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileManagerProvider).value;
    final userName = profile?.name ?? "User";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: const HomeAppBarProfile(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getGreeting(), style: Theme.of(context).textTheme.bodyMedium),
            Text(userName, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchView()),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}
