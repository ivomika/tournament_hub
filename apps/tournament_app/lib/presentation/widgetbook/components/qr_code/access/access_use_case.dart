import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';

final qrAccessUseCase = WidgetbookUseCase(
  name: 'access',
  builder: QrAccessUseCase.build,
);

abstract final class QrAccessUseCase {
  static Widget build(BuildContext context) => QrFixture(
    withCode: true,
    data: context.knobs.string(
      label: 'QR payload',
      initialValue: 'http://host.local/spectator',
    ),
  );
}
