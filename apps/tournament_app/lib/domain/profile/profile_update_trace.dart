import 'package:tournament_app/domain/identifiers/unique_identifier.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/profile_log_event.dart';
import 'package:tournament_app/domain/logging/profile_logger.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';

enum _UpdatePhase { validation, reading, writing }

/// Диагностирует факты сценария, не принимает решение о сохранении.
final class ProfileUpdateTrace {
  ProfileUpdateTrace({
    required this.logger,
    required this.execution,
    required this.attempt,
  });

  final ProfileLogger logger;
  final UniqueIdentifier execution;
  final int attempt;
  final Stopwatch _elapsed = Stopwatch()..start();
  _UpdatePhase _phase = _UpdatePhase.validation;

  void started() => _write(
    ProfileLogEvent.updateStarted,
    'Начата проверка запроса изменения имени; запись ещё не запускалась.',
  );

  void reading() {
    _phase = _UpdatePhase.reading;
    _write(
      ProfileLogEvent.readStarted,
      'Читается актуальный LocalProfile перед изменением.',
    );
  }

  void readCompleted({required bool found}) => _write(
    ProfileLogEvent.readCompleted,
    found ? 'Профиль прочитан; существующий ProfileId будет сохранён.' : 'Профиль отсутствует; регистрация вместо редактирования не выполняется.',
  );

  void writing() {
    _phase = _UpdatePhase.writing;
    _write(
      ProfileLogEvent.writeStarted,
      'Начата запись имени в LocalProfile без замены ProfileId.',
    );
  }

  void succeeded({required bool changed}) => _write(
    ProfileLogEvent.updateSucceeded,
    changed
        ? 'Repository подтвердил сохранение; доступен возврат к профилю. Физический flush адаптером не гарантируется.'
        : 'Нормализованное имя не изменилось; повторная запись не нужна.',
  );

  void rejected(ProfileFailureReason reason) => _write(
    ProfileLogEvent.updateRejected,
    'Причина: $reason. Изменение не сохранено; исправьте ввод или восстановите профиль перед повтором.',
    level: LogLevel.warning,
  );

  void failed(Object error, StackTrace stackTrace) {
    final reason = error is ProfileException
        ? error.reason.toString()
        : 'Источник не раскрыл типизированную причину';
    _write(
      ProfileLogEvent.updateFailed,
      'Причина: $reason; источник: ${error.runtimeType}. Подтверждение изменения отсутствует; ввод сохраняется для retry. ${_consequence()}',
      level: LogLevel.error,
      error: error is ProfileException
          ? error
          : _SafeProfileDiagnosticError(error),
      stackTrace: stackTrace,
    );
  }

  void cancelled() => _write(
    ProfileLogEvent.updateCancelled,
    'Владелец отменил ожидание/доставку результата. ${_consequence()}',
  );

  String _consequence() {
    if (_phase == _UpdatePhase.writing) {
      return 'Начатая запись могла сохраниться; rollback не подтверждён. Следующее чтение определит фактические данные.';
    }
    return 'Запись не начиналась; сценарий не изменил сохранённые данные.';
  }

  void _write(
    ProfileLogEvent event,
    String details, {
    LogLevel level = LogLevel.info,
    Object? error,
    StackTrace? stackTrace,
  }) {
    logger.log(
      event,
      level: level,
      message:
          'Выполнение: ${execution.value}\nПопытка: $attempt\nДействие: изменение имени LocalProfile\nЭтап: ${_phase.name}\nПрошло: ${_elapsed.elapsedMilliseconds} ms\n$details',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Сохраняет оригинальную cause для диагностики, не печатает её payload.
final class _SafeProfileDiagnosticError implements Exception {
  const _SafeProfileDiagnosticError(this.cause);

  final Object cause;

  @override
  String toString() => 'Profile update source failure: ${cause.runtimeType}';
}
