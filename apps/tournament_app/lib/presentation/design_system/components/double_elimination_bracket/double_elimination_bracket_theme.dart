import 'dart:ui';

import 'package:flutter/material.dart';

class DoubleEliminationBracketTheme
    extends ThemeExtension<DoubleEliminationBracketTheme> {
  const DoubleEliminationBracketTheme({
    required this.connector,
    required this.winnerConnector,
    required this.loserConnector,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.viewportHeight,
    required this.nodeWidth,
    required this.nodeHeight,
    required this.columnGap,
    required this.rowGap,
    required this.losersOffset,
    required this.padding,
    required this.lineWidth,
    required this.minScale,
    required this.maxScale,
  });

  final Color connector;
  final Color winnerConnector;
  final Color loserConnector;
  final double canvasWidth;
  final double canvasHeight;
  final double viewportHeight;
  final double nodeWidth;
  final double nodeHeight;
  final double columnGap;
  final double rowGap;
  final double losersOffset;
  final double padding;
  final double lineWidth;
  final double minScale;
  final double maxScale;

  @override
  DoubleEliminationBracketTheme copyWith({
    Color? connector,
    Color? winnerConnector,
    Color? loserConnector,
    double? canvasWidth,
    double? canvasHeight,
    double? viewportHeight,
    double? nodeWidth,
    double? nodeHeight,
    double? columnGap,
    double? rowGap,
    double? losersOffset,
    double? padding,
    double? lineWidth,
    double? minScale,
    double? maxScale,
  }) => DoubleEliminationBracketTheme(
    connector: connector ?? this.connector,
    winnerConnector: winnerConnector ?? this.winnerConnector,
    loserConnector: loserConnector ?? this.loserConnector,
    canvasWidth: canvasWidth ?? this.canvasWidth,
    canvasHeight: canvasHeight ?? this.canvasHeight,
    viewportHeight: viewportHeight ?? this.viewportHeight,
    nodeWidth: nodeWidth ?? this.nodeWidth,
    nodeHeight: nodeHeight ?? this.nodeHeight,
    columnGap: columnGap ?? this.columnGap,
    rowGap: rowGap ?? this.rowGap,
    losersOffset: losersOffset ?? this.losersOffset,
    padding: padding ?? this.padding,
    lineWidth: lineWidth ?? this.lineWidth,
    minScale: minScale ?? this.minScale,
    maxScale: maxScale ?? this.maxScale,
  );

  @override
  DoubleEliminationBracketTheme lerp(
    covariant DoubleEliminationBracketTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return DoubleEliminationBracketTheme(
      connector: Color.lerp(connector, other.connector, t)!,
      winnerConnector: Color.lerp(winnerConnector, other.winnerConnector, t)!,
      loserConnector: Color.lerp(loserConnector, other.loserConnector, t)!,
      canvasWidth: lerpDouble(canvasWidth, other.canvasWidth, t)!,
      canvasHeight: lerpDouble(canvasHeight, other.canvasHeight, t)!,
      viewportHeight: lerpDouble(viewportHeight, other.viewportHeight, t)!,
      nodeWidth: lerpDouble(nodeWidth, other.nodeWidth, t)!,
      nodeHeight: lerpDouble(nodeHeight, other.nodeHeight, t)!,
      columnGap: lerpDouble(columnGap, other.columnGap, t)!,
      rowGap: lerpDouble(rowGap, other.rowGap, t)!,
      losersOffset: lerpDouble(losersOffset, other.losersOffset, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      lineWidth: lerpDouble(lineWidth, other.lineWidth, t)!,
      minScale: lerpDouble(minScale, other.minScale, t)!,
      maxScale: lerpDouble(maxScale, other.maxScale, t)!,
    );
  }
}
