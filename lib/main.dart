import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp_bloc/DI/dependency_injection.dart';
import 'package:notesapp_bloc/config/theme/custom_theme.dart';
import 'package:notesapp_bloc/core/routes/app_routes.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/detail/detail_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/home/home_bloc.dart';
import 'package:notesapp_bloc/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Bloc.observer = NoteObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  DependencyInjection<HomeBloc>()..add(HomeEventGetAllData()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes().router,
        theme: CustomTheme.darkTheme,
      ),
    );
  }
}
