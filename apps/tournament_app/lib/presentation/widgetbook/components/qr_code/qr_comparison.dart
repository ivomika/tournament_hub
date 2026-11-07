import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class QrComparison {
  static final spec = ComparisonSpec(
    component: 'qr-code',
    title: 'AppQrCode',
    goldenDirectory: 'lib/presentation/design_system/components/qr_code/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final code in [true, false])
          ComparisonScenario(
            id: '${viewport.name}-${code ? 'access' : 'graphic'}',
            title: '${viewport.name} · ${code ? 'access' : 'graphic'}',
            viewport: viewport,
            webSelector:
                '#c-qr .kit-component:nth-child(${code ? 1 : 2}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .flow-qr-preview',
            builder: (context) => QrFixture(withCode: code),
            controls: [
              const ComparisonControl.type(
                id: 'surface',
                webSelector: ':scope',
                type: ClipRRect,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.radius,
                ],
              ),
              const ComparisonControl.type(
                id: 'graphic',
                webSelector: 'svg',
                type: Image,
                properties: [ComparisonProperty.rect],
              ),
              if (code)
                const ComparisonControl.text(
                  id: 'code',
                  webSelector: '.flow-qr-session',
                  textRange: true,
                  value: '4827 1930 615',
                  properties: [
                    ComparisonProperty.fontSize,
                    ComparisonProperty.fontWeight,
                    ComparisonProperty.color,
                    ComparisonProperty.baseline,
                  ],
                ),
            ],
            note: 'Реальный Flutter surface/code; graphic — готовая alpha-mask исходного SVG fixture. Encoder/создание сессии не входят в DS.',
          ),
    ],
  );
}
