import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_validation_exception.dart';

void main() {
  group('Локальный профиль', () {
    test('создаётся и очищает внешние пробелы', () {
      final profile = LocalProfile.create(
        id: ' player-id ',
        nickname: '  Илья  ',
      );

      expect(profile.id.value, 'player-id');
      expect(profile.nickname.value, 'Илья');
    });

    test('изменяет nickname, сохраняя identity', () {
      final profile = LocalProfile.create(id: 'player-id', nickname: 'Илья');

      final renamed = profile.rename('Новый nickname');

      expect(renamed.id, same(profile.id));
      expect(renamed.nickname.value, 'Новый nickname');
    });

    test('сравнивает одинаковые профили по значениям', () {
      final first = LocalProfile.create(id: 'player-id', nickname: 'Игрок');
      final second = LocalProfile.create(id: 'player-id', nickname: 'Игрок');

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('отклоняет пустой nickname', () {
      expect(
        () => LocalProfile.create(id: 'player-id', nickname: '   '),
        throwsA(isA<LocalProfileValidationException>()),
      );
    });

    test('отклоняет пустую identity', () {
      expect(
        () => LocalProfile.create(id: '  ', nickname: 'Игрок'),
        throwsA(isA<LocalProfileValidationException>()),
      );
    });
  });
}
