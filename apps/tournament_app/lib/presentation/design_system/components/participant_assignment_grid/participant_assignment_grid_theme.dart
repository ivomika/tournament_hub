import 'dart:ui';

import 'package:flutter/material.dart';

class AssignmentGridTheme extends ThemeExtension<AssignmentGridTheme> {
  const AssignmentGridTheme({
    required this.mediumBreakpoint,
    required this.expandedBreakpoint,
    required this.gap,
    required this.compactColumns,
    required this.mediumColumns,
    required this.expandedColumns,
  });

  final double mediumBreakpoint;
  final double expandedBreakpoint;
  final double gap;
  final int compactColumns;
  final int mediumColumns;
  final int expandedColumns;

  @override
  AssignmentGridTheme copyWith({
    double? mediumBreakpoint,
    double? expandedBreakpoint,
    double? gap,
    int? compactColumns,
    int? mediumColumns,
    int? expandedColumns,
  }) => AssignmentGridTheme(
    mediumBreakpoint: mediumBreakpoint ?? this.mediumBreakpoint,
    expandedBreakpoint: expandedBreakpoint ?? this.expandedBreakpoint,
    gap: gap ?? this.gap,
    compactColumns: compactColumns ?? this.compactColumns,
    mediumColumns: mediumColumns ?? this.mediumColumns,
    expandedColumns: expandedColumns ?? this.expandedColumns,
  );

  @override
  AssignmentGridTheme lerp(covariant AssignmentGridTheme? other, double t) {
    if (other == null) return this;
    return AssignmentGridTheme(
      mediumBreakpoint: lerpDouble(
        mediumBreakpoint,
        other.mediumBreakpoint,
        t,
      )!,
      expandedBreakpoint: lerpDouble(
        expandedBreakpoint,
        other.expandedBreakpoint,
        t,
      )!,
      gap: lerpDouble(gap, other.gap, t)!,
      compactColumns: t < 0.5 ? compactColumns : other.compactColumns,
      mediumColumns: t < 0.5 ? mediumColumns : other.mediumColumns,
      expandedColumns: t < 0.5 ? expandedColumns : other.expandedColumns,
    );
  }
}
