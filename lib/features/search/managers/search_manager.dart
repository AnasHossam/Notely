import 'package:notely/features/home/managers/home_note_manager.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/repositories/note_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_manager.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  void set(String query) => state = query;
}

@riverpod
class SearchManager extends _$SearchManager {
  @override
  FutureOr<List<NoteEntity>> build() async {
    final query = ref.watch(searchQueryProvider);

    ref.watch(notesUpdateStreamProvider);

    if (query.isEmpty) {
      return [];
    }

    final repository = ref.read(noteRepositoryProvider);
    return repository.searchNotes(query);
  }
}
