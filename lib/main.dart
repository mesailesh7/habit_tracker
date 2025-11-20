import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/main_page.dart';

void main() {
  runApp(const MyApp());
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
