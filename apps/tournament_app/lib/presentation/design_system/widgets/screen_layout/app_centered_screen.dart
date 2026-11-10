import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';

class AppCenteredScreen extends StatelessWidget {
  const AppCenteredScreen({
    required this.header,
    required this.child,
    this.footer,
    this.stretchContent = false,
    super.key,
  });
  final Widget header, child;
  final Widget? footer;
  final bool stretchContent;
  @override
  Widget build(BuildContext context) {
    final appearance = AppScreenLayoutTheme.of(context);
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          header,
          SizedBox(height: appearance.gap),
          if (appearance.desktop)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: appearance.stretch,
                  children: [
                    SizedBox(height: appearance.utilityTop),
                    Center(
                      child: SizedBox(
                        width: appearance.utilityWidth,
                        height: appearance.utilityHeight,
                        child: AppScreenTile(
                          padding: EdgeInsets.all(appearance.simplePadding),
                          child: child,
                        ),
                      ),
                    ),
                    if (footer != null) ...[
                      SizedBox(height: appearance.gap),
                      Center(
                        child: SizedBox(
                          width: appearance.utilityWidth,
                          child: Align(
                            alignment: appearance.rightAlign,
                            child: SizedBox(
                              width: appearance.utilityAction,
                              child: footer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else ...[
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: stretchContent
                      ? SizedBox(width: appearance.fullWidth, child: child)
                      : child,
                ),
              ),
            ),
            SizedBox(
              height: appearance.utilityReserve,
              child: Align(alignment: appearance.bottomAlign, child: footer),
            ),
          ],
        ],
      ),
    );
  }
}
