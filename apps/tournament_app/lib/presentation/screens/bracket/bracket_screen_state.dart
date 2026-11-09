import 'package:flutter/foundation.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_map/app_bracket_map.dart';

@immutable
class BracketScreenState {
  const BracketScreenState({
    required this.diagram,
    required this.zoomLabel,
    required this.controlsExpanded,
    required this.detail,
  });
  final AppBracketDiagram diagram;
  final String zoomLabel, detail;
  final bool controlsExpanded;
}
