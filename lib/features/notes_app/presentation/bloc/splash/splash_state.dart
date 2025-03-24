part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashLoadedState extends SplashState {}

class SplashRetryState extends SplashState {
  final int retryCount;

  const SplashRetryState({required this.retryCount});

  @override
  List<Object?> get props => [retryCount];
}
