import 'package:notely/features/note/domain/note_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:notely/features/note/repositories/hive_note_repository.dart';

part 'note_repository.g.dart';

@riverpod
NoteRepository noteRepository(Ref ref) {
  return HiveNoteRepository();
}

abstract class NoteRepository {
  Future<void> saveNote(NoteEntity note);
  Future<List<NoteEntity>> getNotes(
      {int offset = 0, int limit = 10, String? tag});
  Future<NoteEntity?> getNote(String id);
  Future<List<String>> getAllTags();
  Future<void> deleteNote(String id);
  Future<void> deleteNotes(List<String> ids);
  Future<List<NoteEntity>> searchNotes(String query);
  Stream<List<String>> watchAllTags();
  Stream<String> watchNotes();
  Future<void> deleteAllNotes();
}
