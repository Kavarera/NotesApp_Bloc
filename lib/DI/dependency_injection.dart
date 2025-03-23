import 'package:get_it/get_it.dart';
import 'package:notesapp_bloc/features/notes_app/data/data_sources/note_local_datasource.dart';
import 'package:notesapp_bloc/features/notes_app/data/repositories/category_repository_imp.dart';
import 'package:notesapp_bloc/features/notes_app/data/repositories/note_repository_imp.dart';
import 'package:notesapp_bloc/features/notes_app/domain/repositories/category_repository.dart';
import 'package:notesapp_bloc/features/notes_app/domain/repositories/note_repository.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/add_new_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/delete_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/delete_note_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/get_all_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/get_all_note_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/update_note_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/detail/detail_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/home/home_bloc.dart';

import '../features/notes_app/domain/usecases/add_new_note_usecase.dart';

final DependencyInjection = GetIt.instance;

Future<void> init() async {
  // Register all dependencies

  // SQFLITE
  DependencyInjection.registerLazySingleton(() => NoteLocalDataSource());

  // REPOSITORY
  // NoteRepository
  DependencyInjection.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: DependencyInjection()),
  );

  // CategoryRepository
  DependencyInjection.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(localDataSource: DependencyInjection()),
  );

  // USECASE
  // NOTE
  DependencyInjection.registerLazySingleton(
    () => InsertNoteUseCase(noteRepository: DependencyInjection()),
  );
  DependencyInjection.registerLazySingleton(
    () => GetAllNoteUsecase(noteRepository: DependencyInjection()),
  );
  DependencyInjection.registerLazySingleton(
    () => DeleteNoteUsecase(noteRepository: DependencyInjection()),
  );
  DependencyInjection.registerLazySingleton(
    () => UpdateNoteUseCase(noteRepository: DependencyInjection()),
  );

  // CATEGORY
  DependencyInjection.registerLazySingleton(
    () => InsertCategoryUseCase(categoryRepository: DependencyInjection()),
  );
  DependencyInjection.registerLazySingleton(
    () => GetAllCategoryUsecase(categoryRepository: DependencyInjection()),
  );
  DependencyInjection.registerLazySingleton(
    () => DeleteCategoryUseCase(categoryRepository: DependencyInjection()),
  );

  // BLOC
  // PAGE HOME
  DependencyInjection.registerFactory(
    () => HomeBloc(
      getAllNoteUsecase: DependencyInjection(),
      deleteNoteUsecase: DependencyInjection(),
      updateNoteUseCase: DependencyInjection(),
      getAllCategoryUsecase: DependencyInjection(),
      insertCategoryUseCase: DependencyInjection(),
      deleteCategoryUseCase: DependencyInjection(),
    ),
  );

  // PAGE DETAIL
  DependencyInjection.registerFactory(
    () => DetailBloc(
      insertNoteUseCase: DependencyInjection(),
      getAllCategoryUsecase: DependencyInjection(),
      updateNoteUseCase: DependencyInjection(),
    ),
  );
}
