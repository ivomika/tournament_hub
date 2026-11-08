import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/component_preview.dart';
import 'package:tournament_app/presentation/design_system/components/stage_progress/app_stage_progress.dart';

final stageProgressCurrentUseCase = WidgetbookUseCase(
  name: 'current',
  builder: StageProgressCurrentUseCase.build,
);

abstract final class StageProgressCurrentUseCase {
  static Widget build(BuildContext context) => const ComponentPreview(
    padded: true,
    child: AppStageProgress(highlights: [false, true, false, false]),
  );
}
