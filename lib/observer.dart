import "dart:developer";

import "package:flutter_bloc/flutter_bloc.dart";

class NoteObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log("${bloc.runtimeType} $change", name: "Bloc Observer - ${bloc.state}");
    super.onChange(bloc, change);
  }
}
