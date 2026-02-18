import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/repositories/note_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_manager.g.dart';

@riverpod
class NoteManager extends _$NoteManager {
  @override
  FutureOr<List<NoteEntity>> build() {
    return [];
  }

  Future<void> saveNote(NoteEntity note) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.saveNote(note);
    ref.invalidate(homeNoteManagerProvider);
    ref.invalidate(homeTagsProvider);
  }

  Future<void> deleteNote(String id) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.deleteNote(id);
    ref.invalidate(homeNoteManagerProvider);
    ref.invalidate(homeTagsProvider);
  }
}
