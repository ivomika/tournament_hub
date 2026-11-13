import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/profile/app_profile_session.dart';
import 'package:tournament_app/presentation/navigation/screen_navigation_controller.dart';
import 'package:tournament_app/presentation/screens/profile/profile_presentation_mapper.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_state.dart';

class ProfileBinding extends StatelessWidget {
  const ProfileBinding({
    required this.profile,
    required this.navigation,
    super.key,
  });

  final AppProfileSession profile;
  final ScreenNavigationController navigation;

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: profile, builder: _screen);

  Widget _screen(BuildContext context, Widget? child) {
    final current = profile.profile;
    return ProfileScreen(
      state: current == null
          ? const ProfileScreenState(name: '', initials: '')
          : ProfilePresentationMapper.map(current),
      onBack: navigation.back,
      onEdit: navigation.editProfile,
      onCreate: null,
      onRecent: null,
      onSettings: null,
      onAbout: null,
      onContact: null,
    );
  }
}
