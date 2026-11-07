import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class NoticeFixture extends StatelessWidget {
  const NoticeFixture({
    this.kind = AppNoticeKind.information,
    this.long = false,
    super.key,
  });
  final AppNoticeKind kind;
  final bool long;
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    return AppNotice(
      kind: kind,
      text: kind == AppNoticeKind.information
          ? (long ? l.noticeInfoLong : l.noticeInfo)
          : l.noticeError,
    );
  }
}
