// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeManager)
const themeManagerProvider = ThemeManagerProvider._();

final class ThemeManagerProvider
    extends $NotifierProvider<ThemeManager, ThemeMode> {
  const ThemeManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'themeManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$themeManagerHash();

  @$internal
  @override
  ThemeManager create() => ThemeManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeManagerHash() => r'a4fcd08fd8d100c685d0be9eadb74756207fc5f0';

abstract class _$ThemeManager extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ThemeMode, ThemeMode>, ThemeMode, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
