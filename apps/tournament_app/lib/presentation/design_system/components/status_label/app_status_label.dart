import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label_theme.dart';
export 'package:tournament_app/presentation/design_system/components/status_label/app_status_label_theme.dart'
    show AppStatusKind, AppStatusTone;

class AppStatusLabel extends StatelessWidget {
  const AppStatusLabel({
    required this.text,
    this.textAlign,
    this.kind = AppStatusKind.live,
    this.tone = AppStatusTone.accent,
    super.key,
  });
  final String text;
  final TextAlign? textAlign;
  final AppStatusKind kind;
  final AppStatusTone tone;
  @override
  Widget build(BuildContext context) {
    final appearance = AppStatusLabelTheme.of(context, kind, tone);
    return kind == AppStatusKind.live
        ? SizedBox(
            width: appearance.fullWidth,
            child: Row(
              children: [
                SizedBox.square(
                  dimension: appearance.dot,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: appearance.color,
                      borderRadius: appearance.radius,
                    ),
                  ),
                ),
                SizedBox(width: appearance.gap),
                Flexible(child: Text(text, style: appearance.style)),
              ],
            ),
          )
        : Text(
            text,
            style: appearance.style,
            textAlign: textAlign,
            textHeightBehavior: appearance.heightBehavior,
          );
  }
}
