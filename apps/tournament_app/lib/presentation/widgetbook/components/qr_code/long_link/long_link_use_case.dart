import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_payload_sample.dart';

final qrLongLinkUseCase = WidgetbookUseCase(
  name: 'Long link',
  builder: QrLongLinkUseCase.build,
);

abstract final class QrLongLinkUseCase {
  static Widget build(BuildContext context) => QrFixture(
    withCode: false,
    data: context.knobs.string(
      label: 'QR payload',
      initialValue: QrPayloadSample.longLink.data,
    ),
  );
}
