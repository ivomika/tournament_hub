import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_painter.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/encoding/app_qr_matrix_encoder.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code_theme.dart';

class AppQrCode extends StatelessWidget {
  const AppQrCode({
    required this.data,
    required this.semanticLabel,
    this.code,
    super.key,
  });
  final String data;
  final String semanticLabel;
  final String? code;
  @override
  Widget build(BuildContext context) {
    final appearance = AppQrCodeTheme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: appearance.extent),
      child: ClipRRect(
        borderRadius: appearance.radius,
        child: ColoredBox(
          color: appearance.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: appearance.stretch,
            children: [
              Semantics(
                image: true,
                label: semanticLabel,
                child: ExcludeSemantics(
                  child: AspectRatio(
                    aspectRatio: appearance.aspectRatio,
                    child: CustomPaint(
                      painter: AppQrPainter(
                        matrix: AppQrMatrixEncoder.encode(data),
                        theme: appearance,
                      ),
                    ),
                  ),
                ),
              ),
              if (code != null)
                Padding(
                  padding: appearance.codePadding,
                  child: FittedBox(
                    fit: appearance.codeFit,
                    child: Text(
                      code!,
                      style: appearance.codeStyle,
                      softWrap: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
