import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/guest_remove/guest_remove_screen.dart';
import 'package:tournament_app/presentation/screens/guest_remove/guest_remove_screen_state.dart';

class GuestRemoveFixture extends StatelessWidget {
  const GuestRemoveFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => GuestRemoveScreen(
    state: GuestRemoveScreenState(
      description: FoundationLocalizations.of(context).screenRemoveGuestNote,
    ),
    onConfirm: null,
    onCancel: action,
  );
}
