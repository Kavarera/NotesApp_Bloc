import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/domain/entities/category_entity.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/add_new_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/delete_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/get_all_category_usecase.dart';
import 'package:notesapp_bloc/features/notes_app/domain/usecases/get_all_note_usecase.dart';

import '../../../domain/entities/note_entity.dart';
import '../../../domain/usecases/delete_note_usecase.dart';
import '../../../domain/usecases/update_note_usecase.dart';

part 'home_state.dart';
part 'home_event.dart';

/// Bloc for handling home events and states
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Notes
  final GetAllNoteUsecase getAllNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;
  final UpdateNoteUseCase updateNoteUseCase;

  // Categories
  final GetAllCategoryUsecase getAllCategoryUsecase;
  final InsertCategoryUseCase insertCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  HomeBloc({
    required this.getAllNoteUsecase,
    required this.deleteNoteUsecase,
    required this.updateNoteUseCase,
    required this.getAllCategoryUsecase,
    required this.insertCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(const HomeStateEmpty()) {
    //category
    on<HomeEventGetAllData>(_onGetAllData);
    on<HomeEventAddCategory>(_onAddCategory);
    on<HomeEventDeleteCategory>(_onDeleteCategory);
    on<HomeEventSelectCategoryFilter>(_onSelectCategoryFilter);
    //note
    on<HomeEventDeleteNote>(_onDeleteNote);
    on<ToggleEventViewMode>(_onToggleViewMode);
    on<HomeEventSearchNote>(_onSearchNote);
  }

  void _onSearchNote(HomeEventSearchNote event, Emitter<HomeState> emit) async {
    if (state is HomeStateLoadedAllData) {
      final cs = state as HomeStateLoadedAllData;
      if (event.text.isNotEmpty) {
        final newNotes =
            cs.notes
                .where(
                  (n) =>
                      n.title.toLowerCase().contains(event.text.toLowerCase()),
                )
                .toList();
        emit(cs.copyWith(notes: newNotes));
      } else {
        final res = await getAllNoteUsecase.call();
        res.fold((err) => emit(HomeStateError(message: err.message)), (notes) {
          emit(cs.copyWith(notes: notes));
        });
      }
    }
  }

  void _onSelectCategoryFilter(
    HomeEventSelectCategoryFilter event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeStateLoadedAllData) {
      final cs = state as HomeStateLoadedAllData;
      if (event.selectedFilterCategory.id! > 0) {
        final newNotes =
            cs.notes
                .where((n) => n.category?.id == event.selectedFilterCategory.id)
                .toList();
        emit(cs.copyWith(notes: newNotes));
      } else {
        final res = await getAllNoteUsecase.call();
        res.fold((err) => emit(HomeStateError(message: err.message)), (notes) {
          emit(cs.copyWith(notes: notes));
        });
      }
    }
  }

  void _onToggleViewMode(ToggleEventViewMode event, Emitter<HomeState> emit) {
    if (state is HomeStateLoadedAllData) {
      final cs = state as HomeStateLoadedAllData;
      emit(cs.copyWith(isGridView: !cs.isGridView));
    }
  }

  /// Handles the event to get all data
  void _onGetAllData(HomeEventGetAllData event, Emitter<HomeState> emit) async {
    emit(const HomeStateLoading());

    final resultNotes = await getAllNoteUsecase.call();
    final resultCategories = await getAllCategoryUsecase.call();

    resultNotes.fold((err) => emit(HomeStateError(message: err.message)), (
      notes,
    ) {
      resultCategories.fold(
        (err) => emit(HomeStateError(message: err.message)),
        (categories) {
          if (categories.isNotEmpty) {
            categories.insert(0, CategoryEntity(name: "All Category", id: -2));
          }
          categories.add(CategoryEntity(name: "Add Category", id: -1));
          emit(
            HomeStateLoadedAllData(
              notes: notes,
              categories: categories,
              isGridView: true,
            ),
          );
        },
      );
    });
  }

  void _onAddCategory(
    HomeEventAddCategory event,
    Emitter<HomeState> emit,
  ) async {
    final result = await insertCategoryUseCase.call(
      CategoryEntity(name: event.categoryName),
    );

    result.fold((err) {
      // emit(HomeStateError(message: err.message));
      log("ERROR: ${err.message}", name: "[LOG] HomeBloc");
    }, (_) => add(const HomeEventGetAllData()));
  }

  void _onDeleteCategory(
    HomeEventDeleteCategory event,
    Emitter<HomeState> emit,
  ) async {
    final result = await deleteCategoryUseCase.call(event.categoryId);
    result.fold(
      (err) {
        emit(HomeStateError(message: err.message));
      },
      (_) {
        if (state is HomeStateLoadedAllData) {
          final cs = state as HomeStateLoadedAllData;
          final newCategories = List<CategoryEntity>.from(cs.categories)
            ..removeWhere((c) => c.id == event.categoryId);

          emit(
            HomeStateLoadedAllData(
              notes: cs.notes,
              categories: newCategories,
              isGridView: cs.isGridView,
            ),
          );
        }
      },
    );
  }

  void _onDeleteNote(HomeEventDeleteNote event, Emitter<HomeState> emit) async {
    final result = await deleteNoteUsecase.call(event.noteEntity.id);
    result.fold(
      (err) {
        emit(HomeStateError(message: err.message));
      },
      (_) {
        if (state is HomeStateLoadedAllData) {
          final cs = state as HomeStateLoadedAllData;
          final newNotes = List<NoteEntity>.from(cs.notes)
            ..removeWhere((n) => n.id == event.noteEntity.id);

          emit(
            HomeStateLoadedAllData(
              notes: newNotes,
              categories: cs.categories,
              isGridView: cs.isGridView,
            ),
          );
        }
      },
    );
  }
}
