import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class AppScreenCanvas extends StatelessWidget {
  const AppScreenCanvas({
    required this.child,
    this.padded = true,
    this.scrollDesktop = false,
    super.key,
  });
  final Widget child;
  final bool padded, scrollDesktop;
  @override
  Widget build(BuildContext context) {
    final t = AppScreenLayoutTheme.of(context),
        l = FoundationLocalizations.of(context);
    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: t.stretch,
          children: [
            if (t.desktop)
              Container(
                decoration: BoxDecoration(border: t.brandBorder),
                height: t.brandHeight,
                child: Padding(
                  padding: t.brandInset,
                  child: Align(
                    alignment: t.centerAlign,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: t.brand,
                            children: [
                              TextSpan(text: l.screenBrand),
                              TextSpan(
                                text: l.screenBrandAccent,
                                style: t.accentBrand,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: padded ? t.inset : EdgeInsets.all(t.zero),
                child: scrollDesktop && t.desktop
                    ? LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              child: SizedBox(
                                height:
                                    constraints.maxHeight <
                                        t.scaledDesktopContentMinHeight
                                    ? t.scaledDesktopContentMinHeight
                                    : constraints.maxHeight,
                                child: child,
                              ),
                            ),
                      )
                    : child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
