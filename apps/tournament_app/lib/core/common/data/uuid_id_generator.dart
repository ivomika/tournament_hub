import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:uuid/uuid.dart';

final class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  @override
  String nextId() => const Uuid().v4();
}
