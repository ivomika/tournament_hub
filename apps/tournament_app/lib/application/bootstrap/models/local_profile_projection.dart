import 'package:equatable/equatable.dart';

final class LocalProfileProjection extends Equatable {
  const LocalProfileProjection({required this.id, required this.nickname});

  final String id;
  final String nickname;

  @override
  List<Object?> get props => [id, nickname];
}
