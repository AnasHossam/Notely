import 'package:hive_ce/hive.dart';
import 'package:notely/features/note/domain/note_entity.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteHiveModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime updatedAt;
  @HiveField(5)
  final String? tag;

  NoteHiveModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.tag,
  });

  factory NoteHiveModel.fromEntity(NoteEntity entity) {
    return NoteHiveModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      tag: entity.tag,
    );
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tag: tag,
    );
  }
}
