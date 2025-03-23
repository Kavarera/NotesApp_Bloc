import 'package:notesapp_bloc/features/notes_app/domain/entities/note_entity.dart';

import 'category_model.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required super.id,
    required super.title,
    required super.content,
    CategoryModel? category,
  }) : super(category: category);

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category:
          json['categoryId'] != null
              ? CategoryModel(
                id: json['categoryId'],
                name: json['category_name'] ?? '',
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      if (category != null) 'categoryId': category?.id,
    };
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      category: category,
    );
  }
}
