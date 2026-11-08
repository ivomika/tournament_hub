import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class AppCenteredScreen extends StatelessWidget {
  const AppCenteredScreen({
    required this.header,
    required this.child,
    this.footer,
    super.key,
  });
  final Widget header, child;
  final Widget? footer;
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
              SizedBox(
                height: t.brandHeight,
                child: Padding(
                  padding: t.brandInset,
                  child: RichText(
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
                ),
              ),
            Expanded(
              child: Padding(
                padding: t.inset,
                child: Column(
                  crossAxisAlignment: t.stretch,
                  children: [
                    header,
                    SizedBox(height: t.gap),
                    if (t.desktop) ...[
                      SizedBox(height: t.utilityTop),
                      Center(
                        child: SizedBox(
                          width: t.utilityWidth,
                          height: t.utilityHeight,
                          child: AppScreenTile(child: child),
                        ),
                      ),
                      if (footer != null) ...[
                        SizedBox(height: t.gap),
                        Center(
                          child: SizedBox(
                            width: t.utilityWidth,
                            child: Align(
                              alignment: t.rightAlign,
                              child: SizedBox(
                                width: t.utilityAction,
                                child: footer!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ] else ...[
                      Expanded(child: Center(child: child)),
                      SizedBox(height: t.utilityReserve),
                      ?footer,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
