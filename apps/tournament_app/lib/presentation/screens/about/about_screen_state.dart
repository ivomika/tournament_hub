import 'package:flutter/foundation.dart';

@immutable
class AboutScreenState {
  const AboutScreenState({required this.version, required this.rulesExpanded});
  final String version;
  final bool rulesExpanded;
}
