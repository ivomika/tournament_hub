import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tournament_app/features/profile/data/database/tables/local_profiles_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [LocalProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor})
    : super(executor ?? driftDatabase(name: 'tournament_hub'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      // Миграции добавляются последовательно при увеличении schemaVersion.
    },
  );
}
