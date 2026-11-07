import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class QrFixture extends StatelessWidget {
  const QrFixture({this.withCode = true, super.key});
  final bool withCode;
  @override
  Widget build(BuildContext context) => AppQrCode(
    graphic: const AppQrGraphic(
      mask: AssetImage('assets/fixtures/qr_demo_mask.png'),
    ),
    semanticLabel: FoundationLocalizations.of(context).qrDescription,
    code: withCode ? '4827 1930 615' : null,
  );
}
