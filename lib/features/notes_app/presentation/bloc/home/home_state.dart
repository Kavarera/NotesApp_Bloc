part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

/// State when there is no data
class HomeStateEmpty extends HomeState {
  const HomeStateEmpty();

  @override
  List<Object> get props => [];
}

/// State when data is loading
class HomeStateLoading extends HomeState {
  const HomeStateLoading();

  @override
  List<Object> get props => [];
}

/// State when there is an error
class HomeStateError extends HomeState {
  final String message;

  const HomeStateError({required this.message});

  @override
  List<Object> get props => [message];
}

/// State when all data is loaded
class HomeStateLoadedAllData extends HomeState {
  final List<NoteEntity> notes;
  final List<CategoryEntity> categories;
  final bool isGridView;

  const HomeStateLoadedAllData({
    required this.notes,
    required this.categories,
    required this.isGridView,
  });

  @override
  List<Object> get props => [notes, categories, isGridView];

  HomeStateLoadedAllData copyWith({
    List<NoteEntity>? notes,
    List<CategoryEntity>? categories,
    bool? isGridView,
  }) {
    return HomeStateLoadedAllData(
      notes: notes ?? this.notes,
      categories: categories ?? this.categories,
      isGridView: isGridView ?? this.isGridView,
    );
  }
}
