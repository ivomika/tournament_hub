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
    final appearance = BootstrapScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final brand = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      children: [
        SizedBox(
          width: appearance.markWidth,
          height: appearance.markHeight,
          child: ColoredBox(color: appearance.accentLogo.color!),
        ),
        SizedBox(height: appearance.small),
        Text(localizations.screenBrand, style: appearance.logo),
        Text(localizations.screenBrandAccent, style: appearance.accentLogo),
      ],
    );
    final cue = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      children: [
        if (state.phase == BootstrapPhase.error)
          SizedBox(
            width: appearance.errorSize,
            height: appearance.errorSize,
            child: FittedBox(
              child: AppIcon(AppGlyph.alert, color: appearance.error),
            ),
          )
        else
          AppProgressIndicator(
            semanticLabel: localizations.screenBootPreparing,
          ),
        SizedBox(height: appearance.small),
        Text(
          state.phase == BootstrapPhase.error
              ? localizations.screenBootError
              : localizations.screenBootPreparing,
          style: appearance.muted,
          textAlign: appearance.leftText,
        ),
      ],
    );
    Widget? action;
    if (state.phase != BootstrapPhase.loading) {
      action = AppButton(
        label: state.phase == BootstrapPhase.error
            ? localizations.screenRetry
            : localizations.screenBootRetrying,
        onPressed: state.phase == BootstrapPhase.error ? onRetry : null,
      );
    }
    return AppScreenCanvas(
      child: appearance.desktop
          ? Row(
              children: [
                Expanded(
                  flex: appearance.primaryFlex,
                  child: Align(
                    alignment: appearance.centerLeft,
                    child: SingleChildScrollView(child: brand),
                  ),
                ),
                SizedBox(width: appearance.gap),
                Expanded(
                  flex: appearance.secondaryFlex,
                  child: SizedBox(
                    height: appearance.utilityHeight,
                    child: AppScreenTile(
                      child: Column(
                        crossAxisAlignment: appearance.stretch,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: appearance.centerLeft,
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  width: appearance.fullWidth,
                                  child: cue,
                                ),
                              ),
                            ),
                          ),
                          if (action != null) ...[
                            SizedBox(height: appearance.gap),
                            action,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: appearance.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        SizedBox(height: appearance.top),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: appearance.blockHeight,
                          ),
                          child: brand,
                        ),
                        SizedBox(height: appearance.blockGap),
                        cue,
                      ],
                    ),
                  ),
                ),
                if (action != null) ...[
                  SizedBox(height: appearance.gap),
                  action,
                ],
              ],
            ),
    );
  }
}
