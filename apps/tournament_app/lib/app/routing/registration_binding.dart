import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/profile/app_profile_session.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/screens/registration/registration_controller.dart';
import 'package:tournament_app/presentation/screens/registration/registration_screen.dart';

class RegistrationBinding extends StatefulWidget {
  const RegistrationBinding({
    required this.profile,
    required this.navigation,
    super.key,
  });

  final AppProfileSession profile;
  final NavigationIntentSink navigation;

  @override
  State<RegistrationBinding> createState() => _RegistrationBindingState();
}

class _RegistrationBindingState extends State<RegistrationBinding> {
  late final _controller = RegistrationController(
    registerProfile: widget.profile.registration,
    navigation: widget.navigation,
  );
  final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    unawaited(_controller.close().catchError(_cleanupFailed));
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _controller, builder: _screen);

  Widget _screen(BuildContext context, Widget? child) => RegistrationScreen(
    state: _controller.state,
    nameController: _name,
    onNameChanged: _controller.nameChanged,
    onSubmit: _submit,
  );

  void _submit() {
    unawaited(_controller.submit().catchError(_cleanupFailed));
  }

  static void _cleanupFailed(Object error, StackTrace stackTrace) =>
      Zone.current.handleUncaughtError(error, stackTrace);
}
