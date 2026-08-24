import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/guest_profile/domain/repositories/guest_profile_collection.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_profile_id.dart';

final class InMemoryGuestProfileCollection implements GuestProfileCollection {
  final List<GuestProfile> _profiles = [];

  @override
  List<GuestProfile> get profiles => List.unmodifiable(_profiles);

  @override
  void add(GuestProfile guest) {
    if (_profiles.any((candidate) => candidate.id == guest.id)) {
      throw StateError('Гость с таким ID уже существует.');
    }
    _profiles.add(guest);
  }

  @override
  void replace(GuestProfile guest) {
    final index = _profiles.indexWhere((candidate) => candidate.id == guest.id);
    if (index == -1) {
      throw StateError('Гость не найден.');
    }
    _profiles[index] = guest;
  }

  @override
  void remove(GuestProfileId id) {
    _profiles.removeWhere((candidate) => candidate.id == id);
  }
}
