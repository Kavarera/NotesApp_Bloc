import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetAllNoteUsecase {
  final NoteRepository noteRepository;

  GetAllNoteUsecase({required this.noteRepository});

  Future<Either<Failure, List<NoteEntity>>> call() async {
    return await noteRepository.getNotes();
  }
}
