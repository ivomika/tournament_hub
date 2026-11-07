import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/header_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class HeaderComparison {
  static final spec = ComparisonSpec(
    component: 'section-header',
    title: 'AppSectionHeader',
    goldenDirectory:
        'lib/presentation/design_system/widgets/section_header/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final sample in HeaderSample.values)
        ComparisonScenario(
          id: 'state-${sample.name}',
          title: sample.name,
        note:sample==HeaderSample.long?'Две строки CSS44.781px / Flutter44px: высота округляется renderer, явный допуск1px только title.':null,
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-header .kit-component:nth-child(${sample == HeaderSample.save
                  ? 2
                  : sample == HeaderSample.edit
                  ? 3
                  : 1}) .kit-component-states .kit-specimen:nth-child(${sample == HeaderSample.long ? 2 : 1}) .flow-header',
          builder: (context) => HeaderFixture(sample: sample),
          controls: _controls(sample),
        ),
      for (final sample in [
        HeaderSample.back,
        HeaderSample.save,
        HeaderSample.edit,
      ])
        for (final viewport in VisualViewport.values)
          ComparisonScenario(
            id: '${viewport.name}-${sample.name}',
            title: '${viewport.name} · ${sample.name}',
            viewport: viewport,
            webSelector:
                '#c-header .kit-component:nth-child(${sample == HeaderSample.save
                    ? 2
                    : sample == HeaderSample.edit
                    ? 3
                    : 1}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .flow-header',
            builder: (context) => HeaderFixture(sample: sample),
            controls: _controls(sample),
          ),
    ],
  );
  static List<ComparisonControl> _controls(HeaderSample sample) => [
    const ComparisonControl.type(
      id: 'back',
      webSelector: 'button:first-child',
      type: AppButton,
      properties: [ComparisonProperty.rect],
    ),
    ComparisonControl.text(
      id: 'title',
        geometryTolerance:sample==HeaderSample.long?1:null,
      webSelector: 'h2',
      value: switch (sample) {
        HeaderSample.back => 'Новый турнир',
        HeaderSample.long => 'Параметры пятничного турнира',
        HeaderSample.save => 'Редактирование',
        HeaderSample.edit => 'Профиль',
      },
      properties: const [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    if (sample == HeaderSample.save || sample == HeaderSample.edit)
      const ComparisonControl.type(
        id: 'action',
        webSelector: 'button:last-child',
        type: AppButton,
        index: 1,
        properties: [ComparisonProperty.rect],
      ),
  ];
}
