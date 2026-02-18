// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteManager)
const noteManagerProvider = NoteManagerProvider._();

final class NoteManagerProvider
    extends $AsyncNotifierProvider<NoteManager, List<NoteEntity>> {
  const NoteManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'noteManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noteManagerHash();

  @$internal
  @override
  NoteManager create() => NoteManager();
}

String _$noteManagerHash() => r'd4ffb4ce1283048db6451e0ef297cf03108ffa90';

abstract class _$NoteManager extends $AsyncNotifier<List<NoteEntity>> {
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
