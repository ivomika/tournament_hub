import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/notice_fixture.dart';

final noticeInlineErrorUseCase = WidgetbookUseCase(
  name: 'inline_error',
  builder: NoticeInlineErrorUseCase.build,
);

abstract final class NoticeInlineErrorUseCase {
  static Widget build(BuildContext context) =>
      const NoticeFixture(kind: AppNoticeKind.inlineError);
}
