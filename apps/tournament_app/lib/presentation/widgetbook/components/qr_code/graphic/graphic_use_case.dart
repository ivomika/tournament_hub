import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';

final qrGraphicUseCase = WidgetbookUseCase(
  name: 'graphic',
  builder: QrGraphicUseCase.build,
);

abstract final class QrGraphicUseCase {
  static Widget build(BuildContext context) => QrFixture(
    withCode: false,
    data: context.knobs.string(
      label: 'QR payload',
      initialValue: 'http://host.local/spectator',
    ),
  );
}
