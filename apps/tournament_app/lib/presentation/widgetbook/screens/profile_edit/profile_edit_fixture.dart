import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen_state.dart';
export 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen_state.dart';

class ProfileEditFixture extends StatefulWidget {
  const ProfileEditFixture({
    required this.phase,
    this.name = 'Иван Михайлов',
    super.key,
  });
  final ProfileEditPhase phase;
  final String name;
  @override
  State<ProfileEditFixture> createState() => _FixtureState();
}

class _FixtureState extends State<ProfileEditFixture> {
  late final controller = TextEditingController(text: widget.name);
  void action() {}
  void changed(String value) {}
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProfileEditScreen(
    state: ProfileEditScreenState(phase: widget.phase, name: widget.name),
    nameController: controller,
    onBack: action,
    onSave: action,
    onNameChanged: changed,
  );
}
