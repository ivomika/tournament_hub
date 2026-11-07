import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/field_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class FieldComparison {
  static final spec = ComparisonSpec(
    component: 'field',
    title: 'AppField',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      ComparisonScenario(
        id: 'singleline-negative-font',
        title: 'Negative control · input font',
        viewport: VisualViewport.mobile,
        webSelector: '#c-field .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(1) .field',
        builder: _filled,
        theme: _changedInputFont,
        controls: _controls(AppFieldKind.singleLine, FieldSample.filled),
        capturePadding: 12,
        expectedFailure: const ComparisonExpectedFailure(
          controlId: 'value',
          property: 'fontSize',
        ),
        note: 'Намеренно изменён размер текста ввода; стенд обязан обнаружить отличие внутри рамки.',
      ),

      for (final kind in AppFieldKind.values)
        for (final sample in FieldSample.values)
          ComparisonScenario(
            id: '${kind.name.toLowerCase()}-${sample.name.toLowerCase()}',
            title: '${kind.name} · ${sample.name}',
            viewport: VisualViewport.mobile,
            webSelector:
                '#c-field .kit-component:nth-child(${kind == AppFieldKind.singleLine ? 1 : 2}) .kit-component-states .kit-specimen:nth-child(${sample.index + 1}) .field',
            builder: (context) => FieldFixture(kind: kind, sample: sample),
            controls: _controls(kind, sample),
            capturePadding: 12,
            note:
                sample == FieldSample.invalid || sample == FieldSample.disabled
                ? 'Состояние предложено в исходном UI kit; валидация вне DS. Source textarea показывает ошибку без смены цвета границы; input использует danger.'
                : null,
          ),
      for (final kind in AppFieldKind.values)
        for (final viewport in VisualViewport.values)
          ComparisonScenario(
            id: '${kind.name.toLowerCase()}-${viewport.name}',
            title: '${kind.name} · ${viewport.name}',
            viewport: viewport,
            webSelector:
                '#c-field .kit-component:nth-child(${kind == AppFieldKind.singleLine ? 1 : 2}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .field',
            builder: (context) => FieldFixture(kind: kind),
            controls: _controls(kind, FieldSample.filled),
            capturePadding: 12,
          ),
    ],
  );
  static Widget _filled(BuildContext context) => const FieldFixture();
  static ThemeData _changedInputFont(ThemeData base) => base.copyWith(
    textTheme: base.textTheme.copyWith(
      bodyMedium: base.textTheme.bodyMedium!.copyWith(
        fontSize:
            base.textTheme.bodyMedium!.fontSize! +
            base.extension<AppSpacing>()!.space4,
      ),
    ),
  );
  static List<ComparisonControl> _controls(
    AppFieldKind kind,
    FieldSample sample,
  ) => [
    ComparisonControl.text(
      id: 'label',
      webSelector: 'label',
      value: kind == AppFieldKind.singleLine ? 'Название' : 'Сообщение',
      properties: const [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    const ComparisonControl.type(
      id: 'input',
      webSelector: 'input,textarea',
      type: DecoratedBox,
      properties: [
        ComparisonProperty.rect,
        ComparisonProperty.background,
        ComparisonProperty.borderWidth,
        ComparisonProperty.borderColor,
        ComparisonProperty.radius,
      ],
    ),
    if (sample != FieldSample.empty)
      const ComparisonControl.type(
        id: 'value',
        webSelector: 'input,textarea',
        type: EditableText,
        textRange: true,
        properties: [
          ComparisonProperty.width,
          ComparisonProperty.fontSize,
          ComparisonProperty.fontWeight,
          ComparisonProperty.color,
          ComparisonProperty.baseline,
        ],
      ),
    if (sample == FieldSample.invalid)
      const ComparisonControl.text(
        id: 'error',
        webSelector: '.error-copy',
        textRange: true,
        value: 'Проверь значение',
        properties: [
          ComparisonProperty.width,
          ComparisonProperty.fontSize,
          ComparisonProperty.color,
          ComparisonProperty.baseline,
        ],
      ),
  ];
}
