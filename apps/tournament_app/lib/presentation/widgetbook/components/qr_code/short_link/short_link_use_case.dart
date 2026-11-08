import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_payload_sample.dart';

final qrShortLinkUseCase = WidgetbookUseCase(
  name: 'Short link',
  builder: QrShortLinkUseCase.build,
);

abstract final class QrShortLinkUseCase {
  static Widget build(BuildContext context) => QrFixture(
    withCode: false,
    data: context.knobs.string(
      label: 'QR payload',
      initialValue: QrPayloadSample.shortLink.data,
    ),
  );
}
