import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';

class BootstrapScreen extends StatelessWidget {
  const BootstrapScreen({
    required this.state,
    required this.onRetry,
    super.key,
  });
  final BootstrapScreenState state;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    final t = BootstrapScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    return AppScreenCanvas(
      child: t.desktop
          ? Row(
              children: [
                Expanded(
                  flex: t.primaryFlex,
                  child: Column(
                    mainAxisAlignment: t.centerMain,
                    crossAxisAlignment: t.start,
                    children: [
                      SizedBox(
                        width: t.markWidth,
                        height: t.markHeight,
                        child: ColoredBox(color: t.accentLogo.color!),
                      ),
                      SizedBox(height: t.small),
                      Text(l.screenBrand, style: t.logo),
                      Text(l.screenBrandAccent, style: t.accentLogo),
                    ],
                  ),
                ),
                SizedBox(width: t.gap),
                Expanded(
                  flex: t.secondaryFlex,
                  child: SizedBox(
                    height: t.utilityHeight,
                    child: AppScreenTile(
                      child: Column(
                        mainAxisAlignment: t.centerMain,
                        crossAxisAlignment: t.centerCross,
                        children: [
                          if (state.phase != BootstrapPhase.error) ...[
                            AppProgressIndicator(
                              semanticLabel: l.screenBootPreparing,
                            ),
                            SizedBox(height: t.gap),
                          ],
                          Text(
                            state.phase == BootstrapPhase.error
                                ? l.screenBootError
                                : l.screenBootPreparing,
                            style: t.muted,
                            textAlign: t.centerText,
                          ),
                          if (state.phase != BootstrapPhase.loading) ...[
                            SizedBox(height: t.gap),
                            AppButton(
                              label: state.phase == BootstrapPhase.error
                                  ? l.screenRetry
                                  : l.screenBootRetrying,
                              onPressed: state.phase == BootstrapPhase.error
                                  ? onRetry
                                  : null,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: t.stretch,
                children: [
                  SizedBox(height: t.top),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: t.blockHeight),
                    child: Column(
                      mainAxisSize: t.min,
                      crossAxisAlignment: t.start,
                      children: [
                        SizedBox(
                          width: t.markWidth,
                          height: t.markHeight,
                          child: ColoredBox(color: t.accentLogo.color!),
                        ),
                        SizedBox(height: t.small),
                        Text(l.screenBrand, style: t.logo),
                        Text(l.screenBrandAccent, style: t.accentLogo),
                      ],
                    ),
                  ),
                  SizedBox(height: t.blockGap),
                  SizedBox(
                    height: t.cueHeight,
                    child: Center(
                      child: state.phase == BootstrapPhase.error
                          ? SizedBox(
                              width: t.errorSize,
                              height: t.errorSize,
                              child: FittedBox(
                                child: AppIcon(AppGlyph.alert, color: t.error),
                              ),
                            )
                          : AppProgressIndicator(
                              semanticLabel: l.screenBootPreparing,
                            ),
                    ),
                  ),
                  SizedBox(height: t.small),
                  Text(
                    state.phase == BootstrapPhase.error
                        ? l.screenBootError
                        : l.screenBootPreparing,
                    style: t.muted,
                    textAlign: t.centerText,
                  ),
                  if (state.phase != BootstrapPhase.loading) ...[
                    SizedBox(height: t.gap),
                    AppButton(
                      label: state.phase == BootstrapPhase.error
                          ? l.screenRetry
                          : l.screenBootRetrying,
                      onPressed: state.phase == BootstrapPhase.error
                          ? onRetry
                          : null,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
