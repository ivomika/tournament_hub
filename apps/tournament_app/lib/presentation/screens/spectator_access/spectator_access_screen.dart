import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/spectator_access/spectator_access_screen_state.dart';
import 'package:tournament_app/presentation/screens/spectator_access/spectator_access_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code.dart';
import 'package:tournament_app/presentation/design_system/widgets/share_link/app_share_link.dart';

class SpectatorAccessScreen extends StatelessWidget {
  const SpectatorAccessScreen({
    required this.state,
    required this.onBack,
    required this.onCopy,
    super.key,
  });
  final SpectatorAccessScreenState state;
  final VoidCallback? onBack, onCopy;
  @override
  Widget build(BuildContext context) {
    final appearance = SpectatorAccessScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final intro = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      mainAxisAlignment: appearance.startMain,
      children: [
        Text(localizations.screenWatchTitle, style: appearance.heroHeading),
        SizedBox(height: appearance.gap),
        if (state.scanHint != null)
          Text(state.scanHint!, style: appearance.caption),
        if (appearance.desktop || !state.noteBelowCode) ...[
          SizedBox(height: appearance.gap),
          Text(state.note, style: appearance.caption),
        ],
      ],
    );
    final code = AppQrCode(
      data: state.qrPayload,
      semanticLabel: localizations.screenQrSpectatorLabel,
      code: localizations.screenViewOnly,
    );
    final address = state.address == null
        ? null
        : AppShareLink(
            role: localizations.screenViewOnly,
            address: state.address!,
            copyLabel: localizations.screenCopySpectator,
            onCopy: onCopy,
          );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenSpectators,
            backLabel: localizations.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: appearance.gap),
          Expanded(
            child: appearance.desktop
                ? Row(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: appearance.stretch,
                          children: [
                            Expanded(child: AppScreenTile(child: intro)),
                            if (address != null) ...[
                              SizedBox(height: appearance.gap),
                              address,
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: AppScreenTile(child: Center(child: code)),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        intro,
                        SizedBox(height: appearance.gap),
                        Center(child: code),
                        if (state.noteBelowCode) ...[
                          SizedBox(height: appearance.gap),
                          Text(state.note, style: appearance.caption),
                        ],
                        if (address != null) ...[
                          SizedBox(height: appearance.gap),
                          address,
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
