import 'package:notesapp_bloc/features/notes_app/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id: id, name: name);
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(id: entity.id, name: entity.name);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
