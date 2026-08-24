import 'package:drift/drift.dart';

@DataClassName('LocalProfileRow')
class LocalProfiles extends Table {
  TextColumn get id => text()();

  TextColumn get nickname => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
