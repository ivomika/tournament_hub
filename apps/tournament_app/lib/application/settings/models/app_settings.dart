import 'package:equatable/equatable.dart';

final class AppSettings extends Equatable {
  const AppSettings({this.confirmTournamentStart = true});

  final bool confirmTournamentStart;

  AppSettings copyWith({bool? confirmTournamentStart}) => AppSettings(
    confirmTournamentStart:
        confirmTournamentStart ?? this.confirmTournamentStart,
  );

  @override
  List<Object?> get props => [confirmTournamentStart];
}
