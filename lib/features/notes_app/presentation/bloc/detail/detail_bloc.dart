import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/domain/entities/note_entity.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/add_new_note_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/get_all_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/update_note_usecase.dart';

import 'dart:developer';
import '../../../domain/entities/category_entity.dart';

part 'detail_state.dart';
part 'detail_event.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final InsertNoteUseCase insertNoteUseCase;
  final GetAllCategoryUsecase getAllCategoryUsecase;
  final UpdateNoteUseCase updateNoteUseCase;

  DetailBloc({
    required this.insertNoteUseCase,
    required this.getAllCategoryUsecase,
    required this.updateNoteUseCase,
  }) : super(NoteDetailInitialState()) {
    on<LoadNoteDetailEvent>(_onLoadNoteDetail);
    on<ToggleEditModeEvent>(_onToggleEditMode);
    on<ChangeSelectedCategoryEvent>(_onChangeSelectedCategory);
    on<SaveNoteEvent>(_onSaveNote);
    on<ChangeTitleEvent>(_onChangeTitle);
  }
  void _onChangeTitle(ChangeTitleEvent event, Emitter<DetailState> emit) {
    if (state is NoteDetailLoadedState) {
      emit((state as NoteDetailLoadedState).copyWith(title: event.title));
    }
  }

  void _onLoadNoteDetail(
    LoadNoteDetailEvent event,
    Emitter<DetailState> emit,
  ) async {
    final categories = await getAllCategoryUsecase.call();
    late List<CategoryEntity> dataCategories;
    categories.fold((err) => dataCategories = [], (categories) {
      dataCategories = categories;
    });
    emit(
      NoteDetailLoadedState(
        title: event.noteEntity?.title ?? "Untitled Note",
        content: event.noteEntity?.content ?? "",
        category: event.noteEntity?.category,
        selectedCategory: event.noteEntity?.category,
        categories: dataCategories,
      ),
    );
  }

  void _onToggleEditMode(ToggleEditModeEvent event, Emitter<DetailState> emit) {
    if (state is NoteDetailLoadedState) {
      emit(
        (state as NoteDetailLoadedState).copyWith(
          isContentEditMode: !event.isEditMode,
          content: event.newContent ?? (state as NoteDetailLoadedState).content,
        ),
      );
    }
  }

  void _onChangeSelectedCategory(
    ChangeSelectedCategoryEvent event,
    Emitter<DetailState> emit,
  ) {
    if (state is NoteDetailLoadedState) {
      if (event.categoryId == null) {
        emit((state as NoteDetailLoadedState).copyWith(selectedCategory: null));
        return;
      } else {
        final selectedCategory = (state as NoteDetailLoadedState).categories
            .firstWhere((element) => element.id == event.categoryId);
        emit(
          (state as NoteDetailLoadedState).copyWith(
            selectedCategory: selectedCategory,
          ),
        );
      }
    }
  }

  void _onSaveNote(SaveNoteEvent event, Emitter<DetailState> emit) async {
    if (state is NoteDetailLoadedState) {
      final currentState = state as NoteDetailLoadedState;
      log("""noteT: ${currentState.title}
            noteC:${currentState.content}
            noteCat:${currentState.selectedCategory}""", name: "DetailBloc");
      final note = NoteEntity(
        id: event.noteId ?? 0,
        title: currentState.title,
        content: currentState.content,
        category: currentState.selectedCategory,
      );
      if (event.noteId == null) {
        //MASUK SECTION UPDATE
        final result = await insertNoteUseCase.call(note);
        result.fold(
          (err) => emit(NoteDetailSavedState()),
          (note) => emit(NoteDetailSavedState()),
        );
      } else {
        final result = await updateNoteUseCase.call(note);
        result.fold(
          (err) {
            log("Error: $err", name: "DetailBloc");
            emit(NoteDetailSavedState());
          },
          (note) {
            emit(NoteDetailSavedState());
          },
        );
      }
    }
  }
}
