// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_selection_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchSelectionManager)
const searchSelectionManagerProvider = SearchSelectionManagerProvider._();

final class SearchSelectionManagerProvider
    extends $NotifierProvider<SearchSelectionManager, Set<String>> {
  const SearchSelectionManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchSelectionManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchSelectionManagerHash();

  @$internal
  @override
  SearchSelectionManager create() => SearchSelectionManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$searchSelectionManagerHash() =>
    r'0676a52320d14c4396cbb302471c47fd80d2cfec';

abstract class _$SearchSelectionManager extends $Notifier<Set<String>> {
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
