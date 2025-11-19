import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/ui/components/timeline_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineView(
                selectedDate: selectedDate.value,
                onSelectedDateChanged: (date) => selectedDate.value = date,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
