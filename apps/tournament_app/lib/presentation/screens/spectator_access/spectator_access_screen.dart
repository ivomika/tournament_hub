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
    final t = SpectatorAccessScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final intro = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      mainAxisAlignment: t.startMain,
      children: [
        Text(l.screenWatchTitle, style: t.heroHeading),
        SizedBox(height: t.gap),
        if (state.scanHint != null) Text(state.scanHint!, style: t.caption),
        if (t.desktop || !state.noteBelowCode) ...[
          SizedBox(height: t.gap),
          Text(state.note, style: t.caption),
        ],
      ],
    );
    final code = AppQrCode(
      data: state.qrPayload,
      semanticLabel: l.screenQrSpectatorLabel,
      code: l.screenViewOnly,
    );
    final address = state.address == null
        ? null
        : AppShareLink(
            role: l.screenViewOnly,
            address: state.address!,
            copyLabel: l.screenCopySpectator,
            onCopy: onCopy,
          );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenSpectators,
            backLabel: l.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: t.desktop
                ? Row(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            Expanded(child: AppScreenTile(child: intro)),
                            if (address != null) ...[
                              SizedBox(height: t.gap),
                              address,
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: t.gap),
                      Expanded(
                        child: AppScreenTile(child: Center(child: code)),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: t.stretch,
                      children: [
                        intro,
                        SizedBox(height: t.gap),
                        Center(child: code),
                        if (state.noteBelowCode) ...[
                          SizedBox(height: t.gap),
                          Text(state.note, style: t.caption),
                        ],
                        if (address != null) ...[
                          SizedBox(height: t.gap),
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
