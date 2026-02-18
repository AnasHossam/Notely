import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/repositories/note_repository.dart';

final homeTagsProvider = StreamProvider<List<String>>((ref) {
  final repository = ref.read(noteRepositoryProvider);
  return repository.watchAllTags();
});

class CurrentTag extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? tag) => state = tag;
}

final currentTagProvider =
    NotifierProvider<CurrentTag, String?>(CurrentTag.new);

final notesUpdateStreamProvider = StreamProvider<String>((ref) {
  return ref.read(noteRepositoryProvider).watchNotes();
});

class HomeNoteManager extends AsyncNotifier<List<NoteEntity>> {
  static const int _pageSize = 10;

  @override
  FutureOr<List<NoteEntity>> build() async {
    final tag = ref.watch(currentTagProvider);

    ref.listen(notesUpdateStreamProvider, (previous, next) {
      if (next.asData?.value != null) {
        _refreshCurrentList();
      }
    });

    return _fetchNotes(offset: 0, tag: tag);
  }

  Future<List<NoteEntity>> _fetchNotes(
      {required int offset, String? tag, int limit = _pageSize}) async {
    final repository = ref.read(noteRepositoryProvider);
    return repository.getNotes(
      offset: offset,
      limit: limit,
      tag: tag,
    );
  }

  Future<void> loadMore() async {
    final currentNotes = state.value ?? [];
    if (state.isLoading) return;

    final tag = ref.read(currentTagProvider);
    try {
      final newNotes = await _fetchNotes(offset: currentNotes.length, tag: tag);
      if (newNotes.isNotEmpty) {
        state = AsyncValue.data([...currentNotes, ...newNotes]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _refreshCurrentList() async {
    final currentNotes = state.value ?? [];
    if (currentNotes.isEmpty) {
      return;
    }

    final tag = ref.read(currentTagProvider);

    try {
      final updatedNotes =
          await _fetchNotes(offset: 0, tag: tag, limit: currentNotes.length);
      state = AsyncValue.data(updatedNotes);
    } catch (e) {
      //
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> deleteNotes(List<String> ids) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.deleteNotes(ids);
  }
}

final homeNoteManagerProvider =
    AsyncNotifierProvider<HomeNoteManager, List<NoteEntity>>(
        HomeNoteManager.new);
