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
    final brand = Column(
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
    );
    final cue = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      children: [
        if (state.phase == BootstrapPhase.error)
          SizedBox(
            width: t.errorSize,
            height: t.errorSize,
            child: FittedBox(child: AppIcon(AppGlyph.alert, color: t.error)),
          )
        else
          AppProgressIndicator(semanticLabel: l.screenBootPreparing),
        SizedBox(height: t.small),
        Text(
          state.phase == BootstrapPhase.error
              ? l.screenBootError
              : l.screenBootPreparing,
          style: t.muted,
          textAlign: t.leftText,
        ),
      ],
    );
    final action = state.phase == BootstrapPhase.loading
        ? null
        : AppButton(
            label: state.phase == BootstrapPhase.error
                ? l.screenRetry
                : l.screenBootRetrying,
            onPressed: state.phase == BootstrapPhase.error ? onRetry : null,
          );
    return AppScreenCanvas(
      child: t.desktop
          ? Row(
              children: [
                Expanded(
                  flex: t.primaryFlex,
                  child: Align(
                    alignment: t.centerLeft,
                    child: SingleChildScrollView(child: brand),
                  ),
                ),
                SizedBox(width: t.gap),
                Expanded(
                  flex: t.secondaryFlex,
                  child: SizedBox(
                    height: t.utilityHeight,
                    child: AppScreenTile(
                      child: Column(
                        crossAxisAlignment: t.stretch,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: t.centerLeft,
                              child: SingleChildScrollView(
                                child: SizedBox(width: t.fullWidth, child: cue),
                              ),
                            ),
                          ),
                          if (action != null) ...[
                            SizedBox(height: t.gap),
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
              crossAxisAlignment: t.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: t.stretch,
                      children: [
                        SizedBox(height: t.top),
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: t.blockHeight),
                          child: brand,
                        ),
                        SizedBox(height: t.blockGap),
                        cue,
                      ],
                    ),
                  ),
                ),
                if (action != null) ...[SizedBox(height: t.gap), action],
              ],
            ),
    );
  }
}
