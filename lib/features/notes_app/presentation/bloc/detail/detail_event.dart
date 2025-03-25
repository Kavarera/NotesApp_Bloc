part of 'detail_bloc.dart';

sealed class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadNoteDetailEvent extends DetailEvent {
  final NoteEntity? noteEntity;
  const LoadNoteDetailEvent({required this.noteEntity});
}

class UpdateNoteTitleEvent extends DetailEvent {
  final String title;
  const UpdateNoteTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateNoteContentEvent extends DetailEvent {
  final String content;
  const UpdateNoteContentEvent(this.content);

  @override
  List<Object?> get props => [content];
}

class SaveNoteEvent extends DetailEvent {
  final int? noteId;

  const SaveNoteEvent({required this.noteId});
}

class ChangeTitleEvent extends DetailEvent {
  final String title;
  const ChangeTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class ChangeSelectedCategoryEvent extends DetailEvent {
  final int? categoryId;

  const ChangeSelectedCategoryEvent({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class ToggleEditModeEvent extends DetailEvent {
  final bool isEditMode;
  final String? newContent;
  const ToggleEditModeEvent({
    required this.isEditMode,
    required this.newContent,
  });
  @override
  List<Object?> get props => [isEditMode];
}
