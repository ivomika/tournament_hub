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
    final t = AppQrCodeTheme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: t.extent),
      child: ClipRRect(
        borderRadius: t.radius,
        child: ColoredBox(
          color: t.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: t.stretch,
            children: [
              Semantics(
                image: true,
                label: semanticLabel,
                child: ExcludeSemantics(
                  child: AspectRatio(
                    aspectRatio: t.aspectRatio,
                    child: CustomPaint(
                      painter: AppQrPainter(
                        matrix: AppQrMatrixEncoder.encode(data),
                        theme: t,
                      ),
                    ),
                  ),
                ),
              ),
              if (code != null)
                Padding(
                  padding: t.codePadding,
                  child: FittedBox(
                    fit: t.codeFit,
                    child: Text(code!, style: t.codeStyle, softWrap: false),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
