import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart' as pretty;

import '../qr_quiet_zone/qr_quiet_zone.dart';
import '../qr_quiet_zone/qr_quiet_zone_theme.dart';
import 'qr_code_symbol.dart';
import 'qr_code_theme.dart';

enum QrCodeState { scannable, unavailable }

enum QrCodeSize { compact, standard, large }

class QrCode extends StatelessWidget {
  const QrCode({
    required this.value,
    required this.semanticLabel,
    this.state = QrCodeState.scannable,
    this.size = QrCodeSize.standard,
    this.unavailableLabel = 'QR-код сейчас недоступен.',
    super.key,
  });

  final String value;
  final String semanticLabel;
  final QrCodeState state;
  final QrCodeSize size;
  final String unavailableLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<QrCodeTheme>()!;
    final dimension = switch (size) {
      QrCodeSize.compact => theme.compactSize,
      QrCodeSize.standard => theme.standardSize,
      QrCodeSize.large => theme.largeSize,
    };

    if (state == QrCodeState.unavailable) {
      return _QrCodeFallback(
        dimension: dimension,
        semanticLabel: unavailableLabel,
      );
    }

    try {
      final code = pretty.QrCode.fromData(
        data: value,
        errorCorrectLevel: pretty.QrErrorCorrectLevel.M,
      );
      final image = pretty.QrImage(code);
      final quietZone = Theme.of(context).extension<QrQuietZoneTheme>()!;
      final modulePitch =
          dimension / (image.moduleCount + quietZone.modules * 2);

      if (modulePitch < theme.minimumModulePitch) {
        return _QrCodeFallback(
          dimension: dimension,
          semanticLabel: unavailableLabel,
        );
      }

      return Semantics(
        image: true,
        label: semanticLabel,
        child: ExcludeSemantics(
          child: SizedBox.square(
            key: const Key('qr-code-image'),
            dimension: dimension,
            child: QrQuietZone(
              moduleCount: image.moduleCount,
              child: pretty.PrettyQrView(
                qrImage: image,
                decoration: pretty.PrettyQrDecoration(
                  shape: qrCodeShape(
                    color: theme.foreground,
                    background: quietZone.background,
                    moduleRoundFactor: theme.moduleRoundFactor,
                    finderOuterRadiusFactor: theme.finderOuterRadiusFactor,
                    finderCenterRadiusFactor: theme.finderCenterRadiusFactor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } on Exception {
      return _QrCodeFallback(
        dimension: dimension,
        semanticLabel: unavailableLabel,
      );
    }
  }
}

class _QrCodeFallback extends StatelessWidget {
  const _QrCodeFallback({required this.dimension, required this.semanticLabel});

  final double dimension;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<QrCodeTheme>()!;

    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox.square(
          key: const Key('qr-code-fallback'),
          dimension: dimension,
          child: ColoredBox(
            color: theme.fallbackBackground,
            child: Center(
              child: Icon(
                Icons.qr_code_2_outlined,
                color: theme.fallbackForeground,
                size: theme.fallbackIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
