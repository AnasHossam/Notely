import 'dart:async';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_ce/hive.dart';
import 'package:notely/core/constants/app_constants.dart';
import 'package:notely/features/note/domain/note_entity.dart';
import 'package:notely/features/note/models/note_model.dart';
import 'package:notely/features/note/repositories/note_repository.dart';

class HiveNoteRepository implements NoteRepository {
  Set<String>? _cachedTags;
  final _tagsController = StreamController<List<String>>.broadcast();

  Future<Box<NoteHiveModel>> _openBox() async {
    if (Hive.isBoxOpen(AppConstants.boxName)) {
      return Hive.box<NoteHiveModel>(AppConstants.boxName);
    }
    return await Hive.openBox<NoteHiveModel>(AppConstants.boxName);
  }

  @override
  Future<void> saveNote(NoteEntity note) async {
    final box = await _openBox();
    final noteModel = NoteHiveModel.fromEntity(note);
    await box.put(note.id, noteModel);
    _invalidateTags();
  }

  @override
  Future<List<NoteEntity>> getNotes({
    int offset = 0,
    int limit = 10,
    String? tag,
  }) async {
    final box = await _openBox();
    var notes = box.values.toList();

    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (tag != null) {
      notes = notes.where((note) => note.tag == tag).toList();
    }

    if (offset >= notes.length) {
      return [];
    }

    final end = (offset + limit < notes.length) ? offset + limit : notes.length;
    return notes.sublist(offset, end).map((e) => e.toEntity()).toList();
  }

  @override
  Future<NoteEntity?> getNote(String id) async {
    final box = await _openBox();
    final model = box.get(id);
    return model?.toEntity();
  }

  @override
  Future<List<String>> getAllTags() async {
    if (_cachedTags != null) {
      final list = _cachedTags!.toList();
      list.sort();
      return list;
    }

    final box = await _openBox();
    final tags = box.values
        .where((note) => note.tag != null && note.tag!.isNotEmpty)
        .map((note) => note.tag!)
        .toSet();

    _cachedTags = tags;
    final list = tags.toList();
    list.sort();
    return list;
  }

  @override
  Future<void> deleteNote(String id) async {
    final box = await _openBox();
    await box.delete(id);
    _invalidateTags();
  }

  @override
  Future<void> deleteNotes(List<String> ids) async {
    final box = await _openBox();
    await box.deleteAll(ids);
    _invalidateTags();
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    final box = await _openBox();
    final allNotes = box.values.toList();

    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();

    final matches = allNotes
        .where((note) {
          if (note.title.toLowerCase().contains(lowerQuery)) return true;

          String plainText = '';
          try {
            final List<dynamic> json = jsonDecode(note.content);
            final doc = Document.fromJson(json);
            plainText = doc.toPlainText().toLowerCase();
          } catch (e) {
            plainText = note.content.toLowerCase();
          }

          return plainText.contains(lowerQuery);
        })
        .map((e) => e.toEntity())
        .toList();

    return matches;
  }

  @override
  Stream<List<String>> watchAllTags() {
    return _tagsController.stream;
  }

  void _invalidateTags() async {
    _cachedTags = null;
    final tags = await getAllTags();
    _tagsController.add(tags);
  }

  @override
  Stream<String> watchNotes() async* {
    final box = await _openBox();
    yield DateTime.now().toIso8601String();
    yield* box.watch().map((event) => DateTime.now().toIso8601String());
  }

  @override
  Future<void> deleteAllNotes() async {
    final box = await _openBox();
    await box.clear();
    _invalidateTags();
  }
}
