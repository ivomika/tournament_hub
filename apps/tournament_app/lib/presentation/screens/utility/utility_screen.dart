import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_centered_screen.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen_state.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator.dart';

class UtilityScreen extends StatelessWidget {
  const UtilityScreen({
    required this.state,
    required this.onBack,
    required this.onRetry,
    super.key,
  });
  final UtilityScreenState state;
  final VoidCallback? onBack, onRetry;
  @override
  Widget build(BuildContext context) {
    final t = UtilityScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final failed = state.phase == UtilityPhase.error;
    return AppCenteredScreen(
      stretchContent: true,
      header: AppSectionHeader(
        title: state.title ?? l.screenLoading,
        backLabel: l.screenBack,
        onBack: onBack,
      ),
      footer: failed
          ? AppButton(
              label: l.screenRetry,
              onPressed: onRetry,
              glyph: AppGlyph.arrow,
            )
          : null,
      child: Column(
        mainAxisSize: t.min,
        crossAxisAlignment: t.start,
        mainAxisAlignment: t.centerMain,
        children: [
          if (failed) ...[
            AppIcon(AppGlyph.alert, color: t.error),
            SizedBox(height: t.gap),
          ],
          if (!failed) ...[
            AppProgressIndicator(
              semanticLabel: state.progressLabel ?? l.screenLoading,
            ),
            SizedBox(height: t.gap),
          ],
          Text(
            state.heading ??
                (failed ? l.screenLoadErrorHero : l.screenLoadingHero),
            style: t.heading,
          ),
          if (state.accent?.isNotEmpty ?? true)
            Text(
              state.accent ??
                  (failed ? l.screenLoadErrorAccent : l.screenLoadingAccent),
              style: t.heading,
            ),
          SizedBox(height: t.gap),
          Text(
            state.note ?? (failed ? l.screenRetryNote : l.screenLoadingNote),
            style: t.caption,
          ),
        ],
      ),
    );
  }
}
