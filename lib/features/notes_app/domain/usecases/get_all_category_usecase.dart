import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetAllCategoryUsecase {
  final CategoryRepository categoryRepository;

  GetAllCategoryUsecase({required this.categoryRepository});

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await categoryRepository.getCategories();
  }
}
