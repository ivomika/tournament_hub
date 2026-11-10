import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
export 'package:tournament_app/presentation/design_system/components/metric/app_metric_theme.dart'
    show AppMetricKind;

class AppMetric extends StatelessWidget {
  const AppMetric({
    required this.value,
    required this.label,
    required this.semanticLabel,
    this.kind = AppMetricKind.plain,
    this.glyph = AppGlyph.trophy,
    super.key,
  });
  final String value, label, semanticLabel;
  final AppMetricKind kind;
  final AppGlyph glyph;
  @override
  Widget build(BuildContext context) {
    final appearance = AppMetricTheme.of(context, kind);
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appearance.background,
          borderRadius: appearance.radius,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: appearance.minHeight,
            minWidth: appearance.fullWidth,
          ),
          child: Padding(
            padding: appearance.padding,
            child: appearance.achievement
                ? Row(
                    children: [
                      if (!appearance.desktop) ...[
                        _MetricIcon(theme: appearance, glyph: glyph),
                        SizedBox(width: appearance.gap),
                      ],
                      Expanded(
                        child: _MetricText(
                          theme: appearance,
                          value: value,
                          label: label,
                        ),
                      ),
                      if (appearance.desktop) ...[
                        SizedBox(width: appearance.gap),
                        _MetricIcon(theme: appearance, glyph: glyph),
                      ],
                    ],
                  )
                : _MetricText(theme: appearance, value: value, label: label),
          ),
        ),
      ),
    );
  }
}

class _MetricIcon extends StatelessWidget {
  const _MetricIcon({required this.theme, required this.glyph});
  final AppMetricTheme theme;
  final AppGlyph glyph;
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: theme.iconOpacity,
    child: AppIcon(glyph, size: AppIconSize.hero, color: theme.foreground),
  );
}

class _MetricText extends StatelessWidget {
  const _MetricText({
    required this.theme,
    required this.value,
    required this.label,
  });
  final AppMetricTheme theme;
  final String value, label;
  @override
  Widget build(BuildContext context) {
    final appearance = theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: appearance.desktop || appearance.achievement
          ? appearance.start
          : appearance.stretch,
      mainAxisAlignment: appearance.desktop && !appearance.achievement
          ? appearance.between
          : appearance.center,
      children: [
        Text(
          value,
          style: appearance.valueStyle,
          textAlign: appearance.textAlign,
        ),
        SizedBox(height: appearance.contentGap),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: appearance.desktop && appearance.achievement
                ? appearance.maxLabelWidth
                : appearance.unrestrictedWidth,
          ),
          child: Text(
            label,
            style: appearance.labelStyle,
            textAlign: appearance.textAlign,
          ),
        ),
      ],
    );
  }
}
