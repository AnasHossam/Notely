import 'package:notely/core/utils/image_provider_utils.dart';

import 'package:notely/core/utils/file_utils.dart';
import 'package:notely/core/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notely/features/profile/managers/user_profile_manager.dart';
import 'package:notely/features/profile/managers/theme_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }
          return _ProfileForm(profile: profile);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProfileForm extends HookConsumerWidget {
  final dynamic profile;

  const _ProfileForm({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: profile.name);
    final photoPath = useState<String?>(profile.photoPath);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final savedPath = await FileUtils.saveImageToAppDirectory(image);
        photoPath.value = savedPath;
      }
    }

    Future<void> showDeleteConfirmation() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => CustomDialog(
          title: 'Delete Account',
          icon: Icons.delete_forever,
          iconColor: Colors.red,
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and will delete all your data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await ref.read(userProfileManagerProvider.notifier).deleteAccount();
        if (context.mounted) {
          // Navigate to onboarding/splash and clear stack
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      backgroundImage:
                          ImageProviderUtils.getImageProvider(photoPath.value),
                      child: photoPath.value == null
                          ? Icon(Icons.add_a_photo,
                              size: 50, color: Theme.of(context).primaryColor)
                          : null,
                    ),
                  ),
                ),
                if (photoPath.value != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => photoPath.value = null,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Theme Mode',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _ThemeListTile(
            label: 'System Default',
            icon: Icons.settings_brightness,
            isSelected: profile.themeMode == 'system',
            onTap: () => ref
                .read(themeManagerProvider.notifier)
                .setThemeMode(ThemeMode.system),
          ),
          _ThemeListTile(
            label: 'Light',
            icon: Icons.light_mode,
            isSelected: profile.themeMode == 'light',
            onTap: () => ref
                .read(themeManagerProvider.notifier)
                .setThemeMode(ThemeMode.light),
          ),
          _ThemeListTile(
            label: 'Dark',
            icon: Icons.dark_mode,
            isSelected: profile.themeMode == 'dark',
            onTap: () => ref
                .read(themeManagerProvider.notifier)
                .setThemeMode(ThemeMode.dark),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              ref.read(userProfileManagerProvider.notifier).updateProfile(
                    profile.copyWith(
                      name: nameController.text.trim(),
                      photoPath: photoPath.value,
                      clearPhoto: photoPath.value == null,
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save Changes'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: showDeleteConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

class _ThemeListTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeListTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(icon, color: isSelected ? Theme.of(context).primaryColor : null),
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
