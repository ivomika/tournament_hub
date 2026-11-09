import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/guest_add/guest_add_screen.dart';
import 'package:tournament_app/presentation/screens/guest_add/guest_add_screen_state.dart';

class GuestAddFixture extends StatefulWidget {
  const GuestAddFixture({super.key});
  @override
  State<GuestAddFixture> createState() => _FixtureState();
}

class _FixtureState extends State<GuestAddFixture> {
  final controller = TextEditingController(text: 'Дмитрий');
  void action() {}
  void changed(String value) {}
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GuestAddScreen(
    state: GuestAddScreenState(
      notice: FoundationLocalizations.of(context).screenGuestBeforeStart,
    ),
    nameController: controller,
    onBack: action,
    onNameChanged: changed,
    onAdd: action,
  );
}
