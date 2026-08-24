import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/guest_profile/domain/repositories/guest_profile_collection.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_profile_id.dart';

final class GuestProfileManager {
  const GuestProfileManager(this._collection, this._idGenerator);

  final GuestProfileCollection _collection;
  final IdGenerator _idGenerator;

  List<GuestProfile> get profiles => _collection.profiles;

  GuestProfile add(String nickname) {
    final guest = GuestProfile.create(
      id: _idGenerator.nextId(),
      nickname: nickname,
    );
    _collection.add(guest);
    return guest;
  }

  GuestProfile rename(GuestProfileId id, String nickname) {
    final current = _collection.profiles.firstWhere(
      (candidate) => candidate.id == id,
      orElse: () => throw StateError('Гость не найден.'),
    );
    final updated = current.rename(nickname);
    _collection.replace(updated);
    return updated;
  }

  void remove(GuestProfileId id) => _collection.remove(id);
}
