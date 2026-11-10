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
    final appearance = AppScreenLayoutTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    return Scaffold(
      backgroundColor: appearance.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: appearance.stretch,
          children: [
            if (appearance.desktop)
              Container(
                decoration: BoxDecoration(border: appearance.brandBorder),
                height: appearance.brandHeight,
                child: Padding(
                  padding: appearance.brandInset,
                  child: Align(
                    alignment: appearance.centerAlign,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: appearance.brand,
                            children: [
                              TextSpan(text: localizations.screenBrand),
                              TextSpan(
                                text: localizations.screenBrandAccent,
                                style: appearance.accentBrand,
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
                padding: padded
                    ? appearance.inset
                    : EdgeInsets.all(appearance.zero),
                child: scrollDesktop && appearance.desktop
                    ? LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              child: SizedBox(
                                height:
                                    constraints.maxHeight <
                                        appearance.scaledDesktopContentMinHeight
                                    ? appearance.scaledDesktopContentMinHeight
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
