import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_payload_sample.dart';

final qrUnicodeLinkUseCase = WidgetbookUseCase(
  name: 'Unicode link',
  builder: QrUnicodeLinkUseCase.build,
);

abstract final class QrUnicodeLinkUseCase {
  static Widget build(BuildContext context) => QrFixture(
    withCode: false,
    data: context.knobs.string(
      label: 'QR payload',
      initialValue: QrPayloadSample.unicodeLink.data,
    ),
  );
}
