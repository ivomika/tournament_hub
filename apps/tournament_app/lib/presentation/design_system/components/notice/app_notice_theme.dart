import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

enum AppNoticeKind { information, operationError, inlineError }

class AppNoticeTheme {
  AppNoticeTheme.of(BuildContext context, AppNoticeKind kind) {
    final t = Theme.of(context);
    error = kind != AppNoticeKind.information;
    color = error ? t.colorScheme.error : t.colorScheme.onSurfaceVariant;
    style = AppTextStyles(t).caption.copyWith(color: color);
    gap = t.extension<AppSpacing>()!.space8;
    start = t.extension<AppFieldMetrics>()!.start;
    glyph = error ? AppGlyph.alert : AppGlyph.info;
  }
  late final bool error;
  late final Color color;
  late final TextStyle style;
  late final double gap;
  late final CrossAxisAlignment start;
  late final AppGlyph glyph;
}
