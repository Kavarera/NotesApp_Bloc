import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository noteRepository;

  UpdateNoteUseCase({required this.noteRepository});

  Future<Either<Failure, void>> call(NoteEntity note) async {
    return await noteRepository.updateNote(note);
  }
}
