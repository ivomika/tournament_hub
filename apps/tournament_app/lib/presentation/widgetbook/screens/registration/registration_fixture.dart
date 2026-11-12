import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen_state.dart';

export 'package:tournament_app/presentation/screens/registration/registration_screen_state.dart';

class RegistrationFixture extends StatefulWidget {
  const RegistrationFixture({required this.state, super.key});

  final RegistrationScreenState state;

  @override
  State<RegistrationFixture> createState() => _RegistrationFixtureState();
}

class _RegistrationFixtureState extends State<RegistrationFixture> {
  late final _name = TextEditingController(text: widget.state.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RegistrationScreen(
    state: widget.state,
    nameController: _name,
    onNameChanged: _changed,
    onSubmit: _submit,
  );

  void _changed(String value) {}

  void _submit() {}
}
