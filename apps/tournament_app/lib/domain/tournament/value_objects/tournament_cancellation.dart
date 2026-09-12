import 'package:equatable/equatable.dart';

final class TournamentCancellation extends Equatable {
  TournamentCancellation({required String reason, required this.cancelledAtUtc})
    : reason = _requireReason(reason) {
    if (!cancelledAtUtc.isUtc) {
      throw ArgumentError.value(
        cancelledAtUtc,
        'cancelledAtUtc',
        'Время отмены должно быть в UTC.',
      );
    }
  }

  final String reason;
  final DateTime cancelledAtUtc;

  static String _requireReason(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, 'reason', 'Причина отмены обязательна.');
    }
    return normalized;
  }

  @override
  List<Object> get props => [reason, cancelledAtUtc];
}
