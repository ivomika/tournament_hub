import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/domain/profile/local_profile.dart';

void main() {
  test('nickname trims whitespace and keeps unicode', () {
    final profile = LocalProfile(id: 'profile-1', nickname: '  Иво 🐉  ');
    expect(profile.nickname, 'Иво 🐉');
  });

  test('empty nickname is rejected', () {
    expect(
      () => LocalProfile(id: 'profile-1', nickname: '   '),
      throwsFormatException,
    );
  });

  test('rename preserves stable profile id', () {
    final profile = LocalProfile(id: 'profile-1', nickname: 'Иво');
    expect(
      profile.rename('Мика'),
      LocalProfile(id: 'profile-1', nickname: 'Мика'),
    );
  });
}
