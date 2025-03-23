part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

/// Event to get all data
class HomeEventGetAllData extends HomeEvent {
  const HomeEventGetAllData();
}

/// Event to add a note
class HomeEventAddNote extends HomeEvent {
  final NoteEntity noteEntity;

  const HomeEventAddNote({required this.noteEntity});

  @override
  List<Object> get props => [noteEntity];
}

/// Event to delete a note
class HomeEventDeleteNote extends HomeEvent {
  final NoteEntity noteEntity;

  const HomeEventDeleteNote({required this.noteEntity});

  @override
  List<Object> get props => [noteEntity];
}

class HomeEventSelectCategoryFilter extends HomeEvent {
  final CategoryEntity selectedFilterCategory;

  const HomeEventSelectCategoryFilter({required this.selectedFilterCategory});

  @override
  List<Object> get props => [selectedFilterCategory];
}

class HomeEventSearchNote extends HomeEvent {
  final String text;
  const HomeEventSearchNote({required this.text});

  @override
  List<Object> get props => [text];
}

/// Event to add a category
class HomeEventAddCategory extends HomeEvent {
  final String categoryName;

  const HomeEventAddCategory({required this.categoryName});

  @override
  List<Object> get props => [categoryName];
}

/// Event to delete a category
class HomeEventDeleteCategory extends HomeEvent {
  final int categoryId;

  const HomeEventDeleteCategory({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

/// Event to toggle the view mode
class ToggleEventViewMode extends HomeEvent {
  const ToggleEventViewMode();
  @override
  List<Object> get props => [];
}
