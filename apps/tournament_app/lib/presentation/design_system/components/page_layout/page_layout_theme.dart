import 'dart:ui';

import 'package:flutter/material.dart';

class PageLayoutTheme extends ThemeExtension<PageLayoutTheme> {
  const PageLayoutTheme({
    required this.expandedBreakpoint,
    required this.panelGap,
    required this.supportingGap,
    required this.focusedMaxWidth,
    required this.splitPrimaryFlex,
    required this.splitSecondaryFlex,
    required this.workspacePrimaryFlex,
    required this.workspaceSecondaryFlex,
    required this.archivePrimaryFlex,
    required this.archiveSecondaryFlex,
    required this.heroPrimaryFlex,
    required this.heroSecondaryFlex,
    required this.flowPrimaryFlex,
    required this.flowSecondaryFlex,
  });

  final double expandedBreakpoint;
  final double panelGap;
  final double supportingGap;
  final double focusedMaxWidth;
  final int splitPrimaryFlex;
  final int splitSecondaryFlex;
  final int workspacePrimaryFlex;
  final int workspaceSecondaryFlex;
  final int archivePrimaryFlex;
  final int archiveSecondaryFlex;
  final int heroPrimaryFlex;
  final int heroSecondaryFlex;
  final int flowPrimaryFlex;
  final int flowSecondaryFlex;

  @override
  PageLayoutTheme copyWith({
    double? expandedBreakpoint,
    double? panelGap,
    double? supportingGap,
    double? focusedMaxWidth,
    int? splitPrimaryFlex,
    int? splitSecondaryFlex,
    int? workspacePrimaryFlex,
    int? workspaceSecondaryFlex,
    int? archivePrimaryFlex,
    int? archiveSecondaryFlex,
    int? heroPrimaryFlex,
    int? heroSecondaryFlex,
    int? flowPrimaryFlex,
    int? flowSecondaryFlex,
  }) => PageLayoutTheme(
    expandedBreakpoint: expandedBreakpoint ?? this.expandedBreakpoint,
    panelGap: panelGap ?? this.panelGap,
    supportingGap: supportingGap ?? this.supportingGap,
    focusedMaxWidth: focusedMaxWidth ?? this.focusedMaxWidth,
    splitPrimaryFlex: splitPrimaryFlex ?? this.splitPrimaryFlex,
    splitSecondaryFlex: splitSecondaryFlex ?? this.splitSecondaryFlex,
    workspacePrimaryFlex: workspacePrimaryFlex ?? this.workspacePrimaryFlex,
    workspaceSecondaryFlex:
        workspaceSecondaryFlex ?? this.workspaceSecondaryFlex,
    archivePrimaryFlex: archivePrimaryFlex ?? this.archivePrimaryFlex,
    archiveSecondaryFlex: archiveSecondaryFlex ?? this.archiveSecondaryFlex,
    heroPrimaryFlex: heroPrimaryFlex ?? this.heroPrimaryFlex,
    heroSecondaryFlex: heroSecondaryFlex ?? this.heroSecondaryFlex,
    flowPrimaryFlex: flowPrimaryFlex ?? this.flowPrimaryFlex,
    flowSecondaryFlex: flowSecondaryFlex ?? this.flowSecondaryFlex,
  );

  @override
  PageLayoutTheme lerp(covariant PageLayoutTheme? other, double t) {
    if (other == null) return this;
    return PageLayoutTheme(
      expandedBreakpoint: lerpDouble(
        expandedBreakpoint,
        other.expandedBreakpoint,
        t,
      )!,
      panelGap: lerpDouble(panelGap, other.panelGap, t)!,
      supportingGap: lerpDouble(supportingGap, other.supportingGap, t)!,
      focusedMaxWidth: lerpDouble(focusedMaxWidth, other.focusedMaxWidth, t)!,
      splitPrimaryFlex: t < 0.5 ? splitPrimaryFlex : other.splitPrimaryFlex,
      splitSecondaryFlex: t < 0.5
          ? splitSecondaryFlex
          : other.splitSecondaryFlex,
      workspacePrimaryFlex: t < 0.5
          ? workspacePrimaryFlex
          : other.workspacePrimaryFlex,
      workspaceSecondaryFlex: t < 0.5
          ? workspaceSecondaryFlex
          : other.workspaceSecondaryFlex,
      archivePrimaryFlex: t < 0.5
          ? archivePrimaryFlex
          : other.archivePrimaryFlex,
      archiveSecondaryFlex: t < 0.5
          ? archiveSecondaryFlex
          : other.archiveSecondaryFlex,
      heroPrimaryFlex: t < 0.5 ? heroPrimaryFlex : other.heroPrimaryFlex,
      heroSecondaryFlex: t < 0.5 ? heroSecondaryFlex : other.heroSecondaryFlex,
      flowPrimaryFlex: t < 0.5 ? flowPrimaryFlex : other.flowPrimaryFlex,
      flowSecondaryFlex: t < 0.5 ? flowSecondaryFlex : other.flowSecondaryFlex,
    );
  }
}
