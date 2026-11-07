import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/score_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class ScoreComparison {
  static final spec = ComparisonSpec(
    component: 'score',
    title: 'AppScore',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final sample in ScoreSample.values)
        ComparisonScenario(
          id: 'pair-${sample.name.toLowerCase()}',
          title: 'Pair · ${sample.name}',
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-score .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(${sample.index + 1}) .competition-score',
          builder: (context) => ScoreFixture(sample: sample),
          controls: _controls(AppScoreKind.pair, sample),
        ),
      for (final sample in [ScoreSample.result, ScoreSample.twoDigits])
        ComparisonScenario(
          id: 'fixed-${sample.name.toLowerCase()}',
          title: 'Fixed · ${sample.name}',
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-score .kit-component:nth-child(2) .kit-component-states .kit-specimen:nth-child(${sample == ScoreSample.result ? 1 : 2}) .result-fixed-score',
          builder: (context) =>
              ScoreFixture(kind: AppScoreKind.fixed, sample: sample),
          controls: _controls(AppScoreKind.fixed, sample),
        ),
      for (final kind in AppScoreKind.values)
        for (final viewport in VisualViewport.values)
          ComparisonScenario(
            id: '${kind.name}-${viewport.name}',
            title: '${kind.name} · ${viewport.name}',
            viewport: viewport,
            webSelector:
                '#c-score .kit-component:nth-child(${kind == AppScoreKind.pair ? 1 : 2}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .${kind == AppScoreKind.pair ? 'competition-score' : 'result-fixed-score'}',
            builder: (context) => ScoreFixture(
              kind: kind,
              sample: kind == AppScoreKind.pair
                  ? ScoreSample.initial
                  : ScoreSample.result,
            ),
            controls: _controls(
              kind,
              kind == AppScoreKind.pair
                  ? ScoreSample.initial
                  : ScoreSample.result,
            ),
          ),
    ],
  );
  static List<ComparisonControl> _controls(
    AppScoreKind kind,
    ScoreSample sample,
  ) {
    final left = switch (sample) {
          ScoreSample.initial => '0',
          ScoreSample.result => '2',
          ScoreSample.twoDigits => '10',
        },
        right = switch (sample) {
          ScoreSample.initial => '0',
          ScoreSample.result => '1',
          ScoreSample.twoDigits => '8',
        };
    return [
      ComparisonControl.text(
        id: 'left',
        webSelector: ':scope',
        textRange: true,
        value: left,
        properties: const [
          ComparisonProperty.fontSize,
          ComparisonProperty.fontWeight,
          ComparisonProperty.color,
          ComparisonProperty.baseline,
        ],
      ),
      if (kind == AppScoreKind.pair) ...[
        const ComparisonControl.text(
          id: 'separator',
          webSelector: 'span',
          value: ':',
          properties: [
            ComparisonProperty.rect,
            ComparisonProperty.fontSize,
            ComparisonProperty.fontWeight,
            ComparisonProperty.color,
            ComparisonProperty.baseline,
          ],
        ),
        ComparisonControl.text(
          id: 'right',
          webSelector: ':scope',
          value: right,
          index: left == right ? 1 : 0,
          properties: const [
            ComparisonProperty.fontSize,
            ComparisonProperty.fontWeight,
            ComparisonProperty.color,
          ],
        ),
      ],
    ];
  }
}
