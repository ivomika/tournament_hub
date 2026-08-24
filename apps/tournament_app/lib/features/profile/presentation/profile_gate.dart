import 'package:flutter/material.dart';
import 'package:tournament_app/features/profile/application/local_profile_controller.dart';
import 'package:tournament_app/features/profile/presentation/profile_screen.dart';
import 'package:tournament_app/features/profile/presentation/profile_onboarding_screen.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({required this.controller, super.key});

  final LocalProfileController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return switch (controller.status) {
          LocalProfileStatus.loading => const _LoadingScreen(),
          LocalProfileStatus.requiresProfile => ProfileOnboardingScreen(
            controller: controller,
          ),
          LocalProfileStatus.authenticated => _HomeScreen(
            controller: controller,
          ),
          LocalProfileStatus.failure => _LoadingFailureScreen(
            message: controller.errorMessage!,
            onRetry: controller.initialize,
          ),
        };
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _LoadingFailureScreen extends StatelessWidget {
  const _LoadingFailureScreen({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Повторить')),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({required this.controller});

  final LocalProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament HUB'),
        actions: [
          IconButton(
            tooltip: 'Открыть профиль',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProfileScreen(controller: controller),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Добро пожаловать, ${controller.profile!.nickname.value}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
