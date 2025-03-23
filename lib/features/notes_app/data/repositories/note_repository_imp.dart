import 'package:dartz/dartz.dart';

import 'package:notesapp_bloc/core/error/failure.dart';

import 'package:notesapp_bloc/features/notes_app/domain/entities/note_entity.dart';

import '../../domain/repositories/note_repository.dart';
import '../data_sources/note_local_datasource.dart';
import '../models/category_model.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> deleteNote(int id) async {
    try {
      await localDataSource.deleteNote(id);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotes() async {
    try {
      final notes = await localDataSource.getNotes();
      return Right(notes.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> insertNote(NoteEntity note) async {
    try {
      final id = await localDataSource.insertNote(
        NoteModel(
          id: note.id,
          title: note.title,
          content: note.content,
          category:
              note.category != null
                  ? CategoryModel.fromEntity(note.category!)
                  : null,
        ),
      );
      return Right(id > 0);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNote(NoteEntity note) async {
    try {
      NoteModel nm = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        category:
            note.category != null
                ? CategoryModel.fromEntity(note.category!)
                : null,
      );
      await localDataSource.updateNote(nm);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
