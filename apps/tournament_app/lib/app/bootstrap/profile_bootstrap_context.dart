import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/profile/app_profile_session.dart';

final class ProfileBootstrapContext {
  const ProfileBootstrapContext({required this.loggers, required this.profile});

  final AppLoggers loggers;
  final AppProfileSession profile;
}
