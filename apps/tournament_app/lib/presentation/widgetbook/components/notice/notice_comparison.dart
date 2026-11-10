import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/notice_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class NoticeComparison {
  static String _resolveText(AppNoticeKind kind, bool long) {
    if (kind != AppNoticeKind.information) {
      return 'Не удалось сохранить. Повтори.';
    }
    if (long) {
      return 'Bracket Reset включён всегда. Второй финал проводится при победе участника из нижней сетки.';
    }
    return 'Bracket Reset включён всегда.';
  }

  static final spec = ComparisonSpec(
    component: 'notice',
    title: 'AppNotice',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final kind in AppNoticeKind.values)
          for (final long
              in (kind == AppNoticeKind.information ? [false, true] : [false]))
            ComparisonScenario(
              id: '${viewport.name}-${kind.name.toLowerCase()}-${long ? 'long' : 'normal'}',
              title:
                  '${viewport.name} · ${kind.name} · ${long ? 'long' : 'normal'}',
              viewport: viewport,
              webSelector:
                  '#c-notice .kit-component:nth-child(${kind.index + 1}) .kit-component-states .kit-specimen:nth-child(${long ? 2 : 1}) p',
              builder: (context) => NoticeFixture(kind: kind, long: long),
              controls: [
                const ComparisonControl.type(
                  id: 'icon',
                  webSelector: '.icon',
                  type: AppIcon,
                  properties: [ComparisonProperty.rect],
                ),
                ComparisonControl.text(
                  id: 'text',
                  webSelector: 'span',
                  value: _resolveText(kind, long),
                  properties: const [
                    ComparisonProperty.rect,
                    ComparisonProperty.fontSize,
                    ComparisonProperty.fontWeight,
                    ComparisonProperty.color,
                    ComparisonProperty.baseline,
                  ],
                ),
              ],
            ),
    ],
  );
}
