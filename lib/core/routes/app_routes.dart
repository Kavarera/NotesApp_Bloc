import 'package:go_router/go_router.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/pages/detail_note_page.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/pages/splash_screen.dart';

import '../../features/notes_app/domain/entities/note_entity.dart';
import '../../features/notes_app/presentation/pages/home_page.dart';

class AppRoutes {
  get router => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: "/",
        name: "home",
        pageBuilder:
            (context, state) => const NoTransitionPage(child: HomePage()),
      ),
      GoRoute(
        path: "/detail",
        name: "detail",
        pageBuilder: (context, state) {
          final note = state.extra as NoteEntity?;
          return NoTransitionPage(child: DetailNotePage(noteEntity: note));
        },
      ),
      GoRoute(
        path: "/",
        name: "splash",
        pageBuilder: (context, state) {
          return NoTransitionPage(child: SplashScreenPage());
        },
      ),
    ],
  );
}
