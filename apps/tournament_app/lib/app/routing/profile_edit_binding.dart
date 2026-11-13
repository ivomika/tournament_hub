import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/profile/app_profile_session.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_controller.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen.dart';

class ProfileEditBinding extends StatefulWidget {
  const ProfileEditBinding({
    required this.profile,
    required this.navigation,
    super.key,
  });

  final AppProfileSession profile;
  final AppNavigationSession navigation;

  @override
  State<ProfileEditBinding> createState() => _ProfileEditBindingState();
}

class _ProfileEditBindingState extends State<ProfileEditBinding> {
  late final _controller = ProfileEditController(
    initialName: widget.profile.profile?.name?.value ?? '',
    updateProfile: widget.profile.updateName,
    navigation: widget.navigation.coordinator.bindToCurrentEntry(),
  );
  late final _name = TextEditingController(text: _controller.state.name);

  @override
  void initState() {
    super.initState();
    widget.navigation.attachEditor(_controller);
  }

  @override
  void dispose() {
    widget.navigation.detachEditor(_controller);
    unawaited(_controller.close().catchError(_report));
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _controller, builder: _screen);

  Widget _screen(BuildContext context, Widget? child) => ProfileEditScreen(
    state: _controller.state,
    nameController: _name,
    onNameChanged: _controller.nameChanged,
    onBack: _back,
    onSave: _save,
  );

  void _save() => unawaited(_controller.save().catchError(_report));

  void _back() => unawaited(_controller.back().catchError(_report));

  static void _report(Object error, StackTrace stackTrace) =>
      Zone.current.handleUncaughtError(error, stackTrace);
}
