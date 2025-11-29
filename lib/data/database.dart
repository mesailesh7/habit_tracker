import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit_tracker/data/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Wins, WinsCompletion])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Win>> getWins() => select(wins).get();

  Stream<List<Win>> watchWins() => select(wins).watch();

  Future<int> createWins(WinsCompanion win) => into(wins).insert(win);

  Future<void> completeWin(int winId, DateTime selectedDate) async {
    await transaction(() async {
   final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999);

    final existingWins = await (select())
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'wins.db'));
    return NativeDatabase.createInBackground(file);
  });
}
