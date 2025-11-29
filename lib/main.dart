import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/database/database.dart';
import 'package:habit_tracker/data/providers/database_provider.dart';
import 'package:habit_tracker/ui/main_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Daily Win',
      darkTheme: FlexThemeData.light(scheme: FlexScheme.blue),
      themeMode: ThemeMode.dark,
      home: const MainPage(),
    );
  }
}
