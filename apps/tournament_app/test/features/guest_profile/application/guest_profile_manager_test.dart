import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/guest_profile/application/guest_profile_manager.dart';
import 'package:tournament_app/features/guest_profile/data/repositories/in_memory_guest_profile_collection.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_profile_id.dart';

import '../../../support/fake_id_generator.dart';

void main() {
  late GuestProfileManager manager;

  setUp(() {
    manager = GuestProfileManager(
      InMemoryGuestProfileCollection(),
      FakeIdGenerator(['guest-1', 'guest-2']),
    );
  });

  test('добавляет, переименовывает и удаляет гостей', () {
    final first = manager.add('Скорпион');
    final second = manager.add('Скорпион');

    expect(manager.profiles, hasLength(2));
    expect(first.id, isNot(second.id));

    final renamed = manager.rename(first.id, 'Саб-Зиро');
    expect(renamed.id, first.id);
    expect(renamed.nickname.value, 'Саб-Зиро');

    manager.remove(second.id);
    expect(manager.profiles, [renamed]);
  });

  test('неизвестного гостя нельзя переименовать', () {
    expect(
      () => manager.rename(GuestProfileId('missing'), 'Рейден'),
      throwsStateError,
    );
  });
}
