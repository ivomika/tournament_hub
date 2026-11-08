import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/contact/contact_screen.dart';
import 'package:tournament_app/presentation/screens/contact/contact_screen_state.dart';

class ContactFixture extends StatefulWidget {
  const ContactFixture({super.key});
  @override
  State<ContactFixture> createState() => _FixtureState();
}

class _FixtureState extends State<ContactFixture> {
  final controller = TextEditingController(text: 'Хочу предложить улучшение…');
  void action() {}
  void changed(String value) {}
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ContactScreen(
    state: ContactScreenState(
      notice: FoundationLocalizations.of(context).screenContactNote,
    ),
    messageController: controller,
    onBack: action,
    onMessageChanged: changed,
    onSend: null,
  );
}
