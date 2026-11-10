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
    final t = AppScreenLayoutTheme.of(context);
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          header,
          SizedBox(height: t.gap),
          if (t.desktop)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: t.stretch,
                  children: [
                    SizedBox(height: t.utilityTop),
                    Center(
                      child: SizedBox(
                        width: t.utilityWidth,
                        height: t.utilityHeight,
                        child: AppScreenTile(
                          padding: EdgeInsets.all(t.simplePadding),
                          child: child,
                        ),
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
                      ? SizedBox(width: t.fullWidth, child: child)
                      : child,
                ),
              ),
            ),
            SizedBox(
              height: t.utilityReserve,
              child: Align(alignment: t.bottomAlign, child: footer),
            ),
          ],
        ],
      ),
    );
  }
}
