import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  Timer? _retryTimer;
  int _retryCount = 0;
  SplashBloc() : super(SplashInitialState()) {
    on<LoadFontsEvent>(_onLoadFonts);
  }

  void _onLoadFonts(LoadFontsEvent event, Emitter<SplashState> emit) async {
    emit(SplashLoadingState());

    try {
      await GoogleFonts.pendingFonts([
        GoogleFonts.poppins(),
        GoogleFonts.comicNeue(),
      ]);

      emit(SplashLoadedState());
      _retryTimer?.cancel(); // Cancel any existing retry timer
    } catch (e) {
      _retryCount++;
      emit(SplashRetryState(retryCount: _retryCount));
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel(); // Cancel any existing retry timer
    _retryTimer = Timer(const Duration(minutes: 1), () {
      add(const LoadFontsEvent()); // Retry loading fonts
    });
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel(); // Cancel the retry timer when the bloc is closed
    return super.close();
  }
}
