import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/date_picker_interaction_options.dart';

void main() => _DatePickerInteractionOptionsTests.run();

abstract final class _DatePickerInteractionOptionsTests {
  static void run() {
    test('picker uses calendar dates without a time component', _dateOnly);
    test('reversed date bounds are rejected', _reversed);
    test('initial date outside inclusive bounds is rejected', _outside);
  }

  static void _dateOnly() {
    final options = DatePickerInteractionOptions(
      initialDate: DateTime.utc(2026, 11, 10, 12, 30),
      currentDate: DateTime(2026, 11, 11, 15),
      firstDate: DateTime(2026, 11, 10, 20),
      lastDate: DateTime(2026, 11, 10, 22),
    );
    expect(options.initialDate, DateTime(2026, 11, 10));
    expect(options.firstDate, options.initialDate);
    expect(options.lastDate, options.initialDate);
    expect(options.currentDate, DateTime(2026, 11, 11));
  }

  static void _reversed() {
    expect(
      () => DatePickerInteractionOptions(
        initialDate: DateTime(2026, 11, 10),
        currentDate: DateTime(2026, 11, 10),
        firstDate: DateTime(2026, 11, 11),
        lastDate: DateTime(2026, 11, 10),
      ),
      throwsArgumentError,
    );
  }

  static void _outside() {
    for (final initial in [DateTime(2026, 11, 9), DateTime(2026, 11, 12)]) {
      expect(
        () => DatePickerInteractionOptions(
          initialDate: initial,
          currentDate: DateTime(2026, 11, 10),
          firstDate: DateTime(2026, 11, 10),
          lastDate: DateTime(2026, 11, 11),
        ),
        throwsArgumentError,
      );
    }
  }
}
