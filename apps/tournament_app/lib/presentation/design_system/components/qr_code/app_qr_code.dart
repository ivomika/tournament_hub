import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code_theme.dart';

/// Supplied module alpha-mask includes quiet zone. Encoding belongs upstream.
class AppQrGraphic {
  const AppQrGraphic({required this.mask});
  final ImageProvider<Object> mask;
}

class AppQrCode extends StatelessWidget {
  const AppQrCode({
    required this.graphic,
    required this.semanticLabel,
    this.code,
    super.key,
  });
  final AppQrGraphic graphic;
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
                    child: Image(
                      image: graphic.mask,
                      color: t.foreground,
                      colorBlendMode: t.blendMode,
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
