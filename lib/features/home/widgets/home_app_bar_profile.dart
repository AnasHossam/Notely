import 'package:notely/core/utils/image_provider_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/features/profile/managers/user_profile_manager.dart';
import 'package:notely/features/profile/views/profile_view.dart';

class HomeAppBarProfile extends ConsumerWidget {
  const HomeAppBarProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileManagerProvider).value;
    final photoPath = profile?.photoPath;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileView()),
        );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
        child: ClipOval(
          child: photoPath != null
              ? ImageProviderUtils.imageFromPath(
                  photoPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                )
              : Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
        ),
      ),
    );
  }
}
