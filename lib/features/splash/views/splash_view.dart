import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/core/utils/app_images.dart';
import 'package:notely/features/home/views/home_view.dart';
import 'package:notely/features/profile/managers/user_profile_manager.dart';
import 'package:notely/features/profile/views/onboarding_view.dart';

class SplashView extends HookConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    final fadeAnimation = useAnimation(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );
    final slideAnimation = useAnimation(
      Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      ),
    );

    final profileAsync = ref.watch(userProfileManagerProvider);
    final isAnimationDone = useState(false);

    useEffect(() {
      animationController.forward();
      // Wait for animation min duration
      final timer = Timer(const Duration(seconds: 3), () {
        isAnimationDone.value = true;
      });
      return timer.cancel;
    }, []);

    useEffect(() {
      if (isAnimationDone.value &&
          !profileAsync.isLoading &&
          !profileAsync.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            final profile = profileAsync.asData?.value;
            if (profile != null && profile.isOnboarded) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomeView()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const OnboardingView()),
              );
            }
          }
        });
      }
      return null;
    }, [isAnimationDone.value, profileAsync]);

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: AlwaysStoppedAnimation(fadeAnimation),
          child: SlideTransition(
            position: AlwaysStoppedAnimation(slideAnimation),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesAppLogo,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Notely',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your personal creative space',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
