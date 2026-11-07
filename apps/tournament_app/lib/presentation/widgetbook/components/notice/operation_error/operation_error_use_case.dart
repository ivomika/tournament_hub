import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/notice_fixture.dart';

final noticeOperationErrorUseCase = WidgetbookUseCase(
  name: 'operation_error',
  builder: NoticeOperationErrorUseCase.build,
);

abstract final class NoticeOperationErrorUseCase {
  static Widget build(BuildContext context) =>
      const NoticeFixture(kind: AppNoticeKind.operationError);
}
