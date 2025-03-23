import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class InsertCategoryUseCase {
  final CategoryRepository categoryRepository;

  InsertCategoryUseCase({required this.categoryRepository});
  Future<Either<Failure, void>> call(CategoryEntity category) async {
    return await categoryRepository.insertCategory(category);
  }
}
