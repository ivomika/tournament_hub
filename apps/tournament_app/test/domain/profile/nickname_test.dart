import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/domain/domain.dart';

void main() {
  group('Nickname', () {
    test('нормализует пробелы по краям', () {
      expect(Nickname('  Илья  ').value, 'Илья');
    });

    test('не принимает пустое значение', () {
      expect(() => Nickname('  '), throwsArgumentError);
    });
  });
}
