import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

final shapeSheetUseCase = WidgetbookUseCase(
  name: 'Sheet / upper corners',
  builder: ShapeSheetUseCase.build,
);

abstract final class ShapeSheetUseCase {
  static Widget build(BuildContext context) => const ShapeSheetFixture();
}

class ShapeSheetFixture extends StatelessWidget {
  const ShapeSheetFixture({this.large = false, super.key});
  final bool large;
  @override
  Widget build(BuildContext context) => AppSurface(
    shape: large ? AppSurfaceShape.largeSheet : AppSurfaceShape.sheet,
    child: Text(
      FoundationLocalizations.of(context).surfaceSample,
      style: AppTextStyles(Theme.of(context)).caption,
    ),
  );
}
