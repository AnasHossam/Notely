import 'package:hive_ce/hive.dart';
import 'package:notely/features/profile/models/user_profile_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProfileRepositoryProvider =
    Provider((ref) => HiveUserProfileRepository());

abstract class UserProfileRepository {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile profile);
  Future<void> deleteUserProfile();
}

class HiveUserProfileRepository implements UserProfileRepository {
  static const String _boxName = 'user_profile_box';
  static const String _profileKey = 'user_profile';

  Future<Box<UserProfile>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<UserProfile>(_boxName);
    }
    return await Hive.openBox<UserProfile>(_boxName);
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    final box = await _openBox();
    return box.get(_profileKey);
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final box = await _openBox();
    await box.put(_profileKey, profile);
  }

  @override
  Future<void> deleteUserProfile() async {
    final box = await _openBox();
    await box.delete(_profileKey);
  }
}
