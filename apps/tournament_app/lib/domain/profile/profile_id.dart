import 'package:tournament_app/domain/identifiers/unique_identifier.dart';

final class ProfileId {
  const ProfileId(this.value);

  final UniqueIdentifier value;

  @override
  bool operator ==(Object other) => other is ProfileId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
