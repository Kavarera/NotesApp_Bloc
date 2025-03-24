import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../DI/dependency_injection.dart';
import '../bloc/splash/splash_bloc.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              DependencyInjection<SplashBloc>()..add(const LoadFontsEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoadedState) {
            context.goNamed("home");
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
              SizedBox(height: 20),
              Center(child: Text("Mengunduh Data...")),
              SizedBox(height: 20),
              BlocBuilder<SplashBloc, SplashState>(
                builder: (context, state) {
                  if (state is SplashRetryState && state.retryCount >= 1) {
                    return Text("Retry: ${state.retryCount}");
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
