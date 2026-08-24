import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_profile_id.dart';

abstract interface class GuestProfileCollection {
  List<GuestProfile> get profiles;

  void add(GuestProfile guest);

  void replace(GuestProfile guest);

  void remove(GuestProfileId id);
}
