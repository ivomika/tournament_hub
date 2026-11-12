import 'package:uuid/uuid.dart';
import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/identifiers/unique_identifier.dart';

final class UuidIdentifierGenerator implements IdentifierGenerator {
  UuidIdentifierGenerator() : _uuid = const Uuid();

  final Uuid _uuid;

  @override
  UniqueIdentifier generate() => UniqueIdentifier(_uuid.v4());
}
