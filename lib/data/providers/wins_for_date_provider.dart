import 'package:habit_tracker/data/database/database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'database_provider.dart';

final winForDateProvider =
    StreamProvider.family<List<WinWithCompletion>, DateTime>((ref, date) {
      final database = ref.watch(databaseProvider);
      return database.watchWinsForDate(date);
    });
