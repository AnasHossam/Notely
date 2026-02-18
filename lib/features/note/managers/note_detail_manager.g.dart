// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_detail_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NoteDetailManager)
const noteDetailManagerProvider = NoteDetailManagerFamily._();

final class NoteDetailManagerProvider
    extends $AsyncNotifierProvider<NoteDetailManager, NoteEntity?> {
  const NoteDetailManagerProvider._(
      {required NoteDetailManagerFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'noteDetailManagerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$noteDetailManagerHash();

  @override
  String toString() {
    return r'noteDetailManagerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NoteDetailManager create() => NoteDetailManager();

  @override
  bool operator ==(Object other) {
    return other is NoteDetailManagerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteDetailManagerHash() => r'5d315a1821fb02b034668bc660688f56143ba222';

final class NoteDetailManagerFamily extends $Family
    with
        $ClassFamilyOverride<NoteDetailManager, AsyncValue<NoteEntity?>,
            NoteEntity?, FutureOr<NoteEntity?>, String> {
  const NoteDetailManagerFamily._()
      : super(
          retry: null,
          name: r'noteDetailManagerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  NoteDetailManagerProvider call(
    String noteId,
  ) =>
      NoteDetailManagerProvider._(argument: noteId, from: this);

  @override
  String toString() => r'noteDetailManagerProvider';
}

abstract class _$NoteDetailManager extends $AsyncNotifier<NoteEntity?> {
  late final _$args = ref.$arg as String;
  String get noteId => _$args;

  FutureOr<NoteEntity?> build(
    String noteId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<NoteEntity?>, NoteEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<NoteEntity?>, NoteEntity?>,
        AsyncValue<NoteEntity?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
