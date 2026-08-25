import 'package:equatable/equatable.dart';

final class MatchPoints extends Equatable {
  const MatchPoints({required this.first, required this.second});

  final int first;
  final int second;

  @override
  List<Object> get props => [first, second];
}
