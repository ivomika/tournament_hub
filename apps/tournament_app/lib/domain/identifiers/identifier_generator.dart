import 'package:tournament_app/domain/identifiers/unique_identifier.dart';

abstract interface class IdentifierGenerator {
  UniqueIdentifier generate();
}
