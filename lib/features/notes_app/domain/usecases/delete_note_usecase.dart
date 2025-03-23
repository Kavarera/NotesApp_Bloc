import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/note_repository.dart';

class DeleteNoteUsecase {
  final NoteRepository noteRepository;

  DeleteNoteUsecase({required this.noteRepository});

  Future<Either<Failure, void>> call(int idNote) async {
    return await noteRepository.deleteNote(idNote);
  }
}
