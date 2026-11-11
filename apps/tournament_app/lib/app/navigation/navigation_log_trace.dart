import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/navigation_log_event.dart';
import 'package:tournament_app/domain/logging/navigation_logger.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';

/// App-адаптер фактов навигации в диагностический порт; не выбирает output.
final class NavigationLogTrace {
  NavigationLogTrace({required this.logger, required this.intent, this.origin});

  final NavigationLogger? logger;
  final NavigationIntent intent;
  NavigationEntryId? origin;

  void requested() => _write(NavigationLogEvent.requested, 'Переход запрошен.');

  void coalesced() => _write(
    NavigationLogEvent.coalesced,
    'Совпадающий запрос присоединён к текущему выполнению.',
    level: LogLevel.debug,
  );

  void started(NavigationEffect effect, NavigationContext context) {
    final target = switch (effect) {
      PushRouteEffect(:final route) => route.runtimeType.toString(),
      GoToRouteEffect(:final route) => route.runtimeType.toString(),
      PopRouteEffect(:final entryId) => 'запись ${entryId.value}',
    };
    _write(
      NavigationLogEvent.started,
      'Эффект: ${effect.runtimeType}\n'
      'Текущий экран: ${context.currentRoute.runtimeType}\n'
      'Назначение: $target\n'
      'Ревизия контекста: ${context.revision}',
    );
  }

  void feedback(NavigationFeedback feedback) {
    final event = switch (feedback) {
      NavigationAccepted() => NavigationLogEvent.accepted,
      NavigationRejected() => NavigationLogEvent.rejected,
      NavigationCancelled() => NavigationLogEvent.cancelled,
      NavigationStale() => NavigationLogEvent.stale,
      NavigationConflict() => NavigationLogEvent.conflict,
      NavigationFailed() => NavigationLogEvent.failed,
    };
    final level = switch (feedback) {
      NavigationFailed() => LogLevel.error,
      NavigationConflict() ||
      NavigationRejected() ||
      NavigationStale() => LogLevel.warning,
      _ => LogLevel.info,
    };
    final reason = switch (feedback) {
      NavigationConflict(:final reason) => '\nПричина: $reason',
      NavigationFailed(:final reason) => '\nПричина: $reason',
      NavigationCancelled() =>
        '\nОжидание отменено; выполненный переход не откатывается.',
      _ => '',
    };
    _write(event, 'Результат: ${feedback.runtimeType}$reason', level: level);
  }

  void failed(Object error, StackTrace stackTrace) => _write(
    NavigationLogEvent.failed,
    'Выполнение завершилось исключением.',
    level: LogLevel.error,
    error: error,
    stackTrace: stackTrace,
  );

  void _write(
    NavigationLogEvent event,
    String details, {
    LogLevel level = LogLevel.info,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final destination = logger;
    if (destination == null) return;

    final entry = origin;
    final entryDescription = entry == null ? 'не определена' : '${entry.value}';
    final tournament = intent;
    final tournamentDetails = tournament is OpenTournamentIntent
        ? '\nТурнир: ${tournament.tournamentId.value}'
        : '';
    destination.log(
      event,
      level: level,
      message:
          'Намерение: ${intent.runtimeType}\n'
          'Исходная запись: $entryDescription$tournamentDetails\n$details',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
