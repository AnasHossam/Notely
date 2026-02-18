import 'package:notely/features/profile/models/user_profile_model.dart';
import 'package:notely/features/profile/repositories/user_profile_repository.dart';
import 'package:notely/features/note/repositories/note_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_manager.g.dart';

@Riverpod(keepAlive: true)
class UserProfileManager extends _$UserProfileManager {
  @override
  FutureOr<UserProfile?> build() async {
    final repository = ref.read(userProfileRepositoryProvider);
    return await repository.getUserProfile();
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userProfileRepositoryProvider);
      await repository.saveUserProfile(profile);
      return profile;
    });
  }

  Future<void> completeOnboarding(
      String name, String? photoPath, String themeMode) async {
    final profile = UserProfile(
      name: name,
      photoPath: photoPath,
      themeMode: themeMode,
      isOnboarded: true,
    );
    await updateProfile(profile);
  }

  Future<void> deleteAccount() async {
    final profileRepository = ref.read(userProfileRepositoryProvider);
    final noteRepository = ref.read(noteRepositoryProvider);

    await profileRepository.deleteUserProfile();
    await noteRepository.deleteAllNotes();

    state = const AsyncValue.data(null);
  }
}
