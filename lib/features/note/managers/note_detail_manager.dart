import 'dart:async';
import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/repositories/note_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'note_detail_manager.g.dart';

@Riverpod(keepAlive: true)
class NoteDetailManager extends _$NoteDetailManager {
  Timer? _debounceTimer;

  @override
  FutureOr<NoteEntity?> build(String noteId) async {
    final repository = ref.read(noteRepositoryProvider);
    return await repository.getNote(noteId);
  }

  void saveNote(NoteEntity note) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      state = AsyncValue.data(note);
      final repository = ref.read(noteRepositoryProvider);
      await repository.saveNote(note);
      ref.invalidate(homeNoteManagerProvider);
      ref.invalidate(homeTagsProvider);
    });
  }

  Future<void> saveImmediately(NoteEntity note) async {
    await Future.delayed(Duration.zero);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    state = AsyncValue.data(note);

    final repository = ref.read(noteRepositoryProvider);
    await repository.saveNote(note);
    ref.invalidate(homeNoteManagerProvider);
    ref.invalidate(homeTagsProvider);
  }
}

class CurrentNoteNotifier extends Notifier<NoteEntity?> {
  @override
  NoteEntity? build() => null;
  void set(NoteEntity? note) => state = note;
}

final currentNoteProvider =
    NotifierProvider<CurrentNoteNotifier, NoteEntity?>(CurrentNoteNotifier.new);
