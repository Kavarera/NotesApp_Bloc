import 'package:dartz/dartz.dart';
import 'package:notesapp_bloc/core/error/failure.dart';
import 'package:notesapp_bloc/features/notes_app/domain/entities/category_entity.dart';
import 'package:notesapp_bloc/features/notes_app/domain/repositories/category_repository.dart';

import '../data_sources/note_local_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final NoteLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await localDataSource.deleteCategory(id);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> insertCategory(CategoryEntity category) async {
    try {
      await localDataSource.insertCategory(
        CategoryModel(id: category.id, name: category.name),
      );
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      await localDataSource.updateCategory(
        CategoryModel(id: category.id, name: category.name),
      );
      return Right(null);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }
}
