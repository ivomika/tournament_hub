import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

enum ComparisonProperty {
  rect,
  center,
  width,
  height,
  fontSize,
  fontWeight,
  lineHeight,
  color,
  background,
  radius,
  borderWidth,
  borderColor,
  baseline,
  strokeWidth,
  opacity,
}

/// Technical fixture identifiers/selectors are external capture protocol data.
class ComparisonControl {
  const ComparisonControl.type({
    required this.id,
    required this.webSelector,
    required Type type,
    this.withinType,
    required this.properties,
    this.index = 0,
    this.geometryTolerance,
    this.baselineTolerance,
    this.textRange = false,
  }) : widgetType = type,
       text = null;
  const ComparisonControl.text({
    required this.id,
    required this.webSelector,
    required String value,
    this.withinType,
    required this.properties,
    this.index = 0,
    this.geometryTolerance,
    this.baselineTolerance,
    this.textRange = false,
  }) : text = value,
       widgetType = null;
  final String id;
  final String webSelector;
  final Type? widgetType;
  final Type? withinType;
  final String? text;
  final int index;
  final List<ComparisonProperty> properties;
  final double? geometryTolerance;
  final double? baselineTolerance;
  final bool textRange;
  Map<String, Object?> toJson() => {
    'id': id,
    'webSelector': webSelector,
    'properties': properties.map((p) => p.name).toList(),
    'textRange': textRange,
    if (geometryTolerance != null || baselineTolerance != null)
      'tolerances': {
        if (geometryTolerance != null) 'geometry': geometryTolerance,
        if (baselineTolerance != null) 'baseline': baselineTolerance,
      },
  };
}

class ComparisonScenario {
  const ComparisonScenario({
    required this.id,
    required this.title,
    required this.viewport,
    required this.webSelector,
    required this.builder,
    required this.controls,
    this.captureSize,
    this.capturePadding = 0,
    this.note,
    this.goldenId,
    this.webClass,
    this.webOpenSelector,
    this.webText,
    this.freezeMilliseconds = 0,
    this.theme,
    this.expectedFailure,
  });
  final String id;
  final String title;
  final VisualViewport viewport;
  final Size? captureSize;
  Size get size => captureSize ?? viewport.size;
  final String webSelector;
  final WidgetBuilder builder;
  final List<ComparisonControl> controls;
  final ThemeData Function(ThemeData)? theme;
  final ComparisonExpectedFailure? expectedFailure;
  final String? goldenId;
  final double capturePadding;
  final String? note;
  final String? webClass;
  final String? webOpenSelector;
  final String? webText;
  final int freezeMilliseconds;
  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'viewport': {'width': size.width, 'height': size.height, 'dpr': 1},
    'webSelector': webSelector,
    'controls': controls.map((c) => c.toJson()).toList(),
    'capturePadding': capturePadding,
    if (note != null) 'note': note,
    if (expectedFailure != null) 'expectedFailure': expectedFailure!.toJson(),
    if (goldenId != null) 'goldenId': goldenId,
    'freezeMilliseconds': freezeMilliseconds,
    if (webClass != null) 'webClass': webClass,
    if (webOpenSelector != null) 'webOpenSelector': webOpenSelector,
    if (webText != null) 'webText': webText,
  };
}

class ComparisonSpec {
  const ComparisonSpec({
    required this.component,
    required this.title,
    required this.scenarios,
    this.geometryTolerance = 0.25,
    this.baselineTolerance = 0.5,
    this.goldenDirectory,
  });
  final String? goldenDirectory;
  final String component;
  final String title;
  final List<ComparisonScenario> scenarios;
  final double geometryTolerance;
  final double baselineTolerance;
  Map<String, Object?> toJson() => {
    'version': 1,
    'component': component,
    'title': title,
    'source': {'url': 'http://127.0.0.1:8094/ui-kit.html'},
    'tolerances': {
      'geometry': geometryTolerance,
      'typography': 0.05,
      'baseline': baselineTolerance,
    },
    'scenarios': scenarios.map((s) => s.toJson()).toList(),
  };
}

class ComparisonExpectedFailure {
  const ComparisonExpectedFailure({
    required this.controlId,
    required this.property,
  });
  final String controlId;
  final String property;
  Map<String, Object?> toJson() => {'control': controlId, 'property': property};
}
