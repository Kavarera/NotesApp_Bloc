import 'package:equatable/equatable.dart';

import 'category_entity.dart';

class NoteEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final CategoryEntity? category;

  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    this.category,
  });

  @override
  List<Object?> get props {
    return [id, title, content, category];
  }
}
