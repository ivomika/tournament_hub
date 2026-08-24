import 'package:tournament_app/core/common/domain/id_generator.dart';

final class FakeIdGenerator implements IdGenerator {
  FakeIdGenerator([Iterable<String> ids = const []]) : _ids = ids.toList();

  final List<String> _ids;
  var _fallbackIndex = 0;

  @override
  String nextId() {
    if (_ids.isNotEmpty) return _ids.removeAt(0);
    _fallbackIndex += 1;
    return 'generated-$_fallbackIndex';
  }
}
