import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class InsertNoteUseCase {
  final NoteRepository noteRepository;

  InsertNoteUseCase({required this.noteRepository});

  Future<Either<Failure, bool>> call(NoteEntity noteEntity) async {
    return await noteRepository.insertNote(noteEntity);
  }
}
