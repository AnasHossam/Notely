// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchQuery)
const searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  const SearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'2ab221c441fd042c8cbf58b17e7e766363f36b6f';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SearchManager)
const searchManagerProvider = SearchManagerProvider._();

final class SearchManagerProvider
    extends $AsyncNotifierProvider<SearchManager, List<NoteEntity>> {
  const SearchManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchManagerHash();

  @$internal
  @override
  SearchManager create() => SearchManager();
}

String _$searchManagerHash() => r'bec01cbcbbf09c4b42713bbab16168295ff224f6';

abstract class _$SearchManager extends $AsyncNotifier<List<NoteEntity>> {
  FutureOr<List<NoteEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<NoteEntity>>, List<NoteEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<NoteEntity>>, List<NoteEntity>>,
        AsyncValue<List<NoteEntity>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
