import 'package:hive_ce/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 1)
class UserProfile {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String? photoPath;
  @HiveField(2)
  final String themeMode;
  @HiveField(3)
  final bool isOnboarded;

  UserProfile({
    required this.name,
    this.photoPath,
    this.themeMode = 'system',
    this.isOnboarded = false,
  });

  UserProfile copyWith({
    String? name,
    String? photoPath,
    String? themeMode,
    bool? isOnboarded,
    bool clearPhoto = false,
  }) {
    return UserProfile(
      name: name ?? this.name,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      themeMode: themeMode ?? this.themeMode,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}
