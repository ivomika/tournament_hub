import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/primitives/color_primitives.dart';

/// Raw defaults. Only the main ThemeData assembly consumes these values.
abstract final class FoundationPrimitives {
  static const avatarContentAlignment = Alignment.center;
  static const avatarLeadingDistribution = TextLeadingDistribution.even;
  static const shapeControl = BorderRadius.all(Radius.circular(8));
  static const shapeNested = BorderRadius.all(Radius.circular(16));
  static const shapeDesktopSurface = BorderRadius.all(Radius.circular(20));
  static const shapeAvatarTile = BorderRadius.all(Radius.circular(22));
  static const shapeSurface = BorderRadius.all(Radius.circular(24));
  static const shapePanel = BorderRadius.all(Radius.circular(32));
  static const shapePill = BorderRadius.all(Radius.circular(999));
  static const shapeSheet = BorderRadius.vertical(top: Radius.circular(24));
  static const motionReveal = Duration(milliseconds: 160);
  static const motionReduced = Duration.zero;
  static const motionCurve = Curves.ease;
  static const elevationFloating = BoxShadow(
    color: ColorPrimitives.floatingShadow,
    offset: Offset(0, 8),
    blurRadius: 24,
  );
  static const elevationSheet = BoxShadow(
    color: ColorPrimitives.sheetShadow,
    offset: Offset(0, -16),
    blurRadius: 48,
  );
  static const elevationDialog = BoxShadow(
    color: ColorPrimitives.dialogShadow,
    offset: Offset(0, 20),
    blurRadius: 64,
  );
  static const layoutPagePadding = EdgeInsets.all(24);
  static const layoutTilePadding = EdgeInsets.all(20);
  static const layoutSmallGap = 8.0;
  static const layoutGap = 16.0;
  static const layoutSectionGap = 32.0;
  static const layoutTileWidth = 320.0;
  static const layoutColorTileHeight = 136.0;
  static const layoutSwatchSize = 44.0;
  static const layoutBorderWidth = 1.0;
  static const layoutCornerRadius = BorderRadius.all(Radius.circular(16));
  static const layoutSwatchRadius = BorderRadius.all(Radius.circular(10));
  static const layoutFullWidth = double.infinity;
  static const layoutTextAlignment = CrossAxisAlignment.start;
  static const layoutCentered = MainAxisAlignment.center;
}
