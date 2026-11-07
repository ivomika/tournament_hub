import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
export 'package:tournament_app/presentation/design_system/components/notice/app_notice_theme.dart'
    show AppNoticeKind;

class AppNotice extends StatelessWidget {
  const AppNotice({
    required this.text,
    this.kind = AppNoticeKind.information,
    this.liveRegion = false,
    super.key,
  });
  final String text;
  final AppNoticeKind kind;
  final bool liveRegion;
  @override
  Widget build(BuildContext context) {
    final t = AppNoticeTheme.of(context, kind);
    return Semantics(
      liveRegion: liveRegion,
      child: Row(
        crossAxisAlignment: t.start,
        children: [
          AppIcon(t.glyph, color: t.color),
          SizedBox(width: t.gap),
          Flexible(child: Text(text, style: t.style)),
        ],
      ),
    );
  }
}
