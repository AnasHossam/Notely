import 'package:notely/core/utils/image_provider_utils.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notely/core/theme/app_colors.dart';
import 'package:notely/features/profile/managers/user_profile_manager.dart';
import 'package:notely/features/profile/managers/theme_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notely/features/home/views/home_view.dart';

class OnboardingView extends HookConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final photoPath = useState<String?>(null);
    final currentThemeMode = ref.watch(themeManagerProvider);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        photoPath.value = image.path;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Let's get started",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Customize your experience",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              backgroundImage:
                                  ImageProviderUtils.getImageProvider(
                                      photoPath.value),
                              child: photoPath.value == null
                                  ? Icon(Icons.add_a_photo_rounded,
                                      size: 32,
                                      color: Theme.of(context).primaryColor)
                                  : null,
                            ),
                          ),
                        ),
                        if (photoPath.value != null)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => photoPath.value = null,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: nameController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Choose Theme",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ThemeOptionCard(
                          label: 'Light',
                          icon: Icons.light_mode_rounded,
                          isSelected: currentThemeMode == ThemeMode.light,
                          onTap: () => ref
                              .read(themeManagerProvider.notifier)
                              .setThemeMode(ThemeMode.light),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ThemeOptionCard(
                          label: 'Dark',
                          icon: Icons.dark_mode_rounded,
                          isSelected: currentThemeMode == ThemeMode.dark,
                          onTap: () => ref
                              .read(themeManagerProvider.notifier)
                              .setThemeMode(ThemeMode.dark),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ThemeOptionCard(
                          label: 'System',
                          icon: Icons.brightness_auto_rounded,
                          isSelected: currentThemeMode == ThemeMode.system,
                          onTap: () => ref
                              .read(themeManagerProvider.notifier)
                              .setThemeMode(ThemeMode.system),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        String themeStr = 'system';
                        if (currentThemeMode == ThemeMode.light) {
                          themeStr = 'light';
                        } else if (currentThemeMode == ThemeMode.dark) {
                          themeStr = 'dark';
                        }

                        await ref
                            .read(userProfileManagerProvider.notifier)
                            .completeOnboarding(
                              nameController.text.trim(),
                              photoPath.value,
                              themeStr,
                            );
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isSelected
        ? primaryColor
        : (isDark ? AppColors.borderDarkColor : AppColors.borderLightColor);

    final updateColor =
        isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent;

    final iconColor = isSelected ? primaryColor : Theme.of(context).hintColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: updateColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
