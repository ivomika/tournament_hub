import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/about/about_screen.dart';
import 'package:tournament_app/presentation/screens/about/about_screen_state.dart';

class AboutFixture extends StatelessWidget {
  const AboutFixture({required this.expanded, super.key});
  final bool expanded;
  static void action() {}
  @override
  Widget build(BuildContext context) => AboutScreen(
    state: AboutScreenState(version: 'Версия · макет', rulesExpanded: expanded),
    onBack: action,
    onToggleRules: action,
  );
}
