part of 'detail_bloc.dart';

sealed class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class NoteDetailInitialState extends DetailState {}

class NoteDetailLoadedState extends DetailState {
  final String title;
  final String content;
  final CategoryEntity? category;
  final CategoryEntity? selectedCategory;
  final List<CategoryEntity> categories;
  final bool isContentEditMode;

  const NoteDetailLoadedState({
    required this.title,
    required this.content,
    required this.category,
    required this.selectedCategory,
    required this.categories,
    this.isContentEditMode = false,
  });

  @override
  List<Object?> get props => [
    title,
    content,
    category,
    selectedCategory,
    categories,
    isContentEditMode,
  ];
}

class NoteDetailSavedState extends DetailState {}

extension CopyWith on NoteDetailLoadedState {
  NoteDetailLoadedState copyWith({
    String? title,
    String? content,
    CategoryEntity? category,
    CategoryEntity? selectedCategory,
    List<CategoryEntity>? categories,
    bool? isContentEditMode,
  }) {
    return NoteDetailLoadedState(
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      selectedCategory: selectedCategory,
      categories: categories ?? this.categories,
      isContentEditMode: isContentEditMode ?? this.isContentEditMode,
    );
  }
}
