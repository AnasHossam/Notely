// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_selection_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeSelectionManager)
const homeSelectionManagerProvider = HomeSelectionManagerProvider._();

final class HomeSelectionManagerProvider
    extends $NotifierProvider<HomeSelectionManager, Set<String>> {
  const HomeSelectionManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeSelectionManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeSelectionManagerHash();

  @$internal
  @override
  HomeSelectionManager create() => HomeSelectionManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$homeSelectionManagerHash() =>
    r'a8da27dd9a982c292a4f28eb4cd635b501017324';

abstract class _$HomeSelectionManager extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<String>, Set<String>>, Set<String>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
