import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/guest_profile/domain/exceptions/guest_profile_validation_exception.dart';

void main() {
  test('гость сохраняет identity при переименовании', () {
    final guest = GuestProfile.create(id: 'guest-1', nickname: '  Китана  ');

    final renamed = guest.rename('Милена');

    expect(guest.nickname.value, 'Китана');
    expect(renamed.id, guest.id);
    expect(renamed.nickname.value, 'Милена');
  });

  test('пустой nickname отклоняется', () {
    expect(
      () => GuestProfile.create(id: 'guest-1', nickname: '   '),
      throwsA(isA<GuestProfileValidationException>()),
    );
  });

  test('value equality учитывает ID и nickname', () {
    expect(
      GuestProfile.create(id: 'guest-1', nickname: 'Скорпион'),
      GuestProfile.create(id: 'guest-1', nickname: 'Скорпион'),
    );
  });
}
