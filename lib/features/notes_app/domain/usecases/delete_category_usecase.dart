import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository categoryRepository;

  DeleteCategoryUseCase({required this.categoryRepository});

  Future<Either<Failure, void>> call(int idCategory) async {
    return await categoryRepository.deleteCategory(idCategory);
  }
}
