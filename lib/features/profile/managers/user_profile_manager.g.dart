// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfileManager)
const userProfileManagerProvider = UserProfileManagerProvider._();

final class UserProfileManagerProvider
    extends $AsyncNotifierProvider<UserProfileManager, UserProfile?> {
  const UserProfileManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userProfileManagerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userProfileManagerHash();

  @$internal
  @override
  UserProfileManager create() => UserProfileManager();
}

String _$userProfileManagerHash() =>
    r'0e2711d684b80c34465b69ef175cad967199a607';

abstract class _$UserProfileManager extends $AsyncNotifier<UserProfile?> {
  FutureOr<UserProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserProfile?>, UserProfile?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserProfile?>, UserProfile?>,
        AsyncValue<UserProfile?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
