import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/spectator_access/spectator_access_screen.dart';
import 'package:tournament_app/presentation/screens/spectator_access/spectator_access_screen_state.dart';

class SpectatorAccessFixture extends StatelessWidget {
  const SpectatorAccessFixture({required this.address, super.key});
  final bool address;
  static void action() {}
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return SpectatorAccessScreen(
      state: SpectatorAccessScreenState(
        qrPayload: 'http://host.local/spectator',
        note: address
            ? localizations.screenSpectatorNote
            : localizations.screenSpectatorDistributionNote,
        noteBelowCode: !address,
        scanHint: address ? null : localizations.screenScan,
        address: address ? 'http://host.local/spectator' : null,
      ),
      onBack: action,
      onCopy: action,
    );
  }
}
