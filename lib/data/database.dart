import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit_tracker/data/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

@DriftDatabase(tables: [Wins, WinsCompletion])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Wins>> getHabits() => select(Wins).get();

  LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'wins.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
