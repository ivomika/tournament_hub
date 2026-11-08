import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';
export 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';

class BootstrapFixture extends StatelessWidget {
  const BootstrapFixture({required this.phase, super.key});
  final BootstrapPhase phase;
  static void retry() {}
  @override
  Widget build(BuildContext context) => BootstrapScreen(
    state: BootstrapScreenState(phase: phase),
    onRetry: retry,
  );
}
