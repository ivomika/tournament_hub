import 'package:flutter/material.dart';

class AppSelectMetrics extends ThemeExtension<AppSelectMetrics> {
  const AppSelectMetrics({
    required this.chevronTurns,
    required this.sheetMaxWidth,
    required this.closeExtent,
    required this.handleWidth,
    required this.handleHeight,
    required this.sheetBottom,
    required this.sheetTitleSize,
    required this.sheetTitleLine,
    required this.desktopLine,
    required this.optionWeight,
    required this.selectedWeight,
  });
  final int chevronTurns;
  final double sheetMaxWidth;
  final double closeExtent;
  final double handleWidth;
  final double handleHeight;
  final double sheetBottom;
  final double sheetTitleSize;
  final double sheetTitleLine;
  final double desktopLine;
  final FontWeight optionWeight;
  final FontWeight selectedWeight;
  @override
  AppSelectMetrics copyWith({
    int? chevronTurns,
    double? sheetMaxWidth,
    double? closeExtent,
    double? handleWidth,
    double? handleHeight,
    double? sheetBottom,
    double? sheetTitleSize,
    double? sheetTitleLine,
    double? desktopLine,
    FontWeight? optionWeight,
    FontWeight? selectedWeight,
  }) => AppSelectMetrics(
    chevronTurns: chevronTurns ?? this.chevronTurns,
    sheetMaxWidth: sheetMaxWidth ?? this.sheetMaxWidth,
    closeExtent: closeExtent ?? this.closeExtent,
    handleWidth: handleWidth ?? this.handleWidth,
    handleHeight: handleHeight ?? this.handleHeight,
    sheetBottom: sheetBottom ?? this.sheetBottom,
    sheetTitleSize: sheetTitleSize ?? this.sheetTitleSize,
    sheetTitleLine: sheetTitleLine ?? this.sheetTitleLine,
    desktopLine: desktopLine ?? this.desktopLine,
    optionWeight: optionWeight ?? this.optionWeight,
    selectedWeight: selectedWeight ?? this.selectedWeight,
  );
  @override
  AppSelectMetrics lerp(
    covariant AppSelectMetrics? other,
    double interpolationAmount,
  ) {
    if (other == null) return this;
    return AppSelectMetrics(
      chevronTurns: interpolationAmount < .5
          ? chevronTurns
          : other.chevronTurns,
      sheetMaxWidth:
          sheetMaxWidth +
          (other.sheetMaxWidth - sheetMaxWidth) * interpolationAmount,
      closeExtent:
          closeExtent + (other.closeExtent - closeExtent) * interpolationAmount,
      handleWidth:
          handleWidth + (other.handleWidth - handleWidth) * interpolationAmount,
      handleHeight:
          handleHeight +
          (other.handleHeight - handleHeight) * interpolationAmount,
      sheetBottom:
          sheetBottom + (other.sheetBottom - sheetBottom) * interpolationAmount,
      sheetTitleSize:
          sheetTitleSize +
          (other.sheetTitleSize - sheetTitleSize) * interpolationAmount,
      sheetTitleLine:
          sheetTitleLine +
          (other.sheetTitleLine - sheetTitleLine) * interpolationAmount,
      desktopLine:
          desktopLine + (other.desktopLine - desktopLine) * interpolationAmount,
      optionWeight: interpolationAmount < .5
          ? optionWeight
          : other.optionWeight,
      selectedWeight: interpolationAmount < .5
          ? selectedWeight
          : other.selectedWeight,
    );
  }
}
