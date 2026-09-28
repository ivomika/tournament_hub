import 'items.dart' as first;
import 'other.dart' as second;
part 'part_piece.dart';

class Box {
  final List<first.Item?> items;
  final second.Item other;
  dynamic unknown;
  int _count = 0;
  Box(this.items, this.other);
  Box.empty() : items = [], other = const second.Item(0);
  int get count => _count;
  set count(int value) => _count = value;
  T choose<T>(T input) {
    _helper();
    return input;
  }

  void _helper() {}
  void invokeDynamic() => unknown.run();
  void unrelatedName() {
    final Item = 1;
    print(Item);
  }
}

enum Mode {
  small(1),
  large(2);

  final int value;
  const Mode(this.value);
  bool get isLarge => value == 2;
}

abstract interface class Store {
  Future<first.Item?> read(String id);
}

abstract class StoreBase implements Store {}

class Extra extends first.Item {
  Extra() : super('x');
}

class GenericBase<T> {}

class GenericExtra extends GenericBase<first.Item> {}

typedef ItemAlias = first.Item;
