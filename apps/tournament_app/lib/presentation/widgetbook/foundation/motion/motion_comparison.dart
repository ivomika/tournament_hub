import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/motion_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class MotionComparison {
  static final spec = ComparisonSpec(
    component: 'motion',
    title: 'Foundation Motion',
    goldenDirectory: 'lib/presentation/design_system/foundation/motion/golden',
    geometryTolerance: 0.5,
    baselineTolerance: 1,
    scenarios: [
      for (final reduced in [false, true])
        for (final revealed in [false, true])
          ComparisonScenario(
            id: '${reduced ? 'reduced' : 'normal'}-${revealed ? 'revealed' : 'closed'}',
            title:
                '${reduced ? 'Reduced' : 'Normal'} · ${revealed ? 'revealed' : 'closed'}',
            viewport: VisualViewport.mobile,
            webSelector:
                RosterComparison.spec.scenarios[revealed ? 1 : 0].webSelector,
            builder: (context) =>
                MotionFixture(reduced: reduced, revealed: revealed),
            controls:
                RosterComparison.spec.scenarios[revealed ? 1 : 0].controls,
            note: 'Сравниваются конечные состояния. Фаза80ms и reduced immediate проверяются native clock; HTML custom waveform не переносится.',
          ),
    ],
  );
}
