import 'package:flutter/material.dart';

/// Standard Material3 indicator. Geometry/motion/colors belong to SDK/main theme.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({required this.semanticLabel, super.key});
  final String semanticLabel;
  @override
  Widget build(BuildContext context) =>
      CircularProgressIndicator(semanticsLabel: semanticLabel);
}
