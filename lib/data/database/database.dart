import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit_tracker/data/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Wins, WinsCompletion])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Win>> getWins() => select(wins).get();

  Stream<List<Win>> watchWins() => select(wins).watch();

  Future<int> createWins(WinsCompanion win) => into(wins).insert(win);

  Stream<List<WinWithCompletion>> watchWinsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = select(wins).join([
      leftOuterJoin(
        winsCompletion,
        winsCompletion.habitId.equalsExp(wins.id) &
            winsCompletion.completedAt.isBetweenValues(startOfDay, endOfDay),
      ),
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        final win = row.readTable(wins);
        final completion = row.readTableOrNull(winsCompletion);
        return WinWithCompletion(win: win, isCompleted: completion != null);
      }).toList();
    });
  }

  Future<void> completeWin(int winId, DateTime selectedDate) async {
    await transaction(() async {
      final startOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final endOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        23,
        59,
        59,
        999,
      );

      final existingWins =
          await (select(winsCompletion)..where(
                (x) =>
                    x.habitId.equals(winId) &
                    x.completedAt.isBetween(
                      Variable(startOfDay),
                      Variable(endOfDay),
                    ),
              ))
              .get();

      if (existingWins.isEmpty) {
        await into(winsCompletion).insert(
          WinsCompletionCompanion(
            habitId: Value(winId),
            completedAt: Value(selectedDate),
          ),
        );

        final win = await (select(
          wins,
        )..where((x) => x.id.equals(winId))).getSingle();
        await update(wins).replace(
          win
              .copyWith(
                streak: win.streak + 1,
                totalCompletions: win.totalCompletions + 1,
              )
              .toCompanion(true),
        );
      }
    });
  }

  Future<void> toggleHabitCompletion(int winId, DateTime selectedDate) {
    return transaction(() async {
      final startOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final endOfDay = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day + 1,
      );

      final existingCompletion =
          await (select(winsCompletion)..where(
                (t) =>
                    t.habitId.equals(winId) &
                    t.completedAt.isBetween(
                      Variable(startOfDay),
                      Variable(endOfDay),
                    ),
              ))
              .get();

      if (existingCompletion.isEmpty) {
        await into(winsCompletion).insert(
          WinsCompletionCompanion.insert(
            habitId: winId,
            completedAt: selectedDate,
          ),
        );

        final habit = await (select(
          wins,
        )..where((t) => t.id.equals(winId))).getSingle();
        await update(wins).replace(
          habit
              .copyWith(
                streak: habit.streak + 1,
                totalCompletions: habit.totalCompletions + 1,
              )
              .toCompanion(true),
        );
      } else {
        await (delete(winsCompletion)..where(
              (t) =>
                  t.habitId.equals(winId) &
                  t.completedAt.isBetween(
                    Variable(startOfDay),
                    Variable(endOfDay),
                  ),
            ))
            .go();

        final habit = await (select(
          wins,
        )..where((t) => t.id.equals(winId))).getSingle();
        await update(wins).replace(
          habit
              .copyWith(
                streak: habit.streak - 1,
                totalCompletions: habit.totalCompletions - 1,
              )
              .toCompanion(true),
        );
      }
    });
  }

  Stream<(int, int)> watchDailySummary(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final completionsStream =
        (select(winsCompletion)..where(
              (t) => t.completedAt.isBetween(
                Variable(startOfDay),
                Variable(endOfDay),
              ),
            ))
            .watch();

    final habitStream = watchWinsForDate(date);
    return Rx.combineLatest2(
      completionsStream,
      habitStream,
      (completions, habits) => (completions.length, habits.length),
    );
  }
}

class WinWithCompletion {
  final Win win;
  final bool isCompleted;

  WinWithCompletion({required this.win, required this.isCompleted});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'wins.db'));
    return NativeDatabase.createInBackground(file);
  });
}
