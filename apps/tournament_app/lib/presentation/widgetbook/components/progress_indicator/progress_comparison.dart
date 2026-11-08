import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/progress_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class ProgressComparison {
  static final spec = ComparisonSpec(
    component: 'progress-indicator',
    title: 'Material3 ProgressIndicator · утверждённое отличие от HTML',
    goldenDirectory:
        'lib/presentation/design_system/components/progress_indicator/golden',
    scenarios: [
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-material3',
          title: '${viewport.name} · Material3',
          viewport: viewport,
          webSelector: '#c-progress .kit-component-states .kit-specimen:first-child .boot-progress',
          builder: _fixed,
          controls: const [],
          expectedFailure: const ComparisonExpectedFailure(
            controlId: 'root',
            property: 'rect.height',
          ),
          note: 'Утверждённое пользователем отличие: ошибочный HTML waveform не переносится. Справа линейный волнистый Material3 Expressive из m3e_progress_indicator, оформленный текущей ProgressIndicatorThemeData/AppProgressMetrics. Expected mismatch подтверждает различие, не совпадение. Фазы start/mid проверяются native golden.',
        ),
    ],
  );
  static Widget _fixed(BuildContext context) =>
      const ProgressFixture(frozen: true);
}
