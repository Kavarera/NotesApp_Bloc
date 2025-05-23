import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int? id;
  final String name;

  const CategoryEntity({this.id, required this.name});

  @override
  List<Object?> get props {
    return [id, name];
  }
}
