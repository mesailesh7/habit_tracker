import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/data/providers/daily_summary_provider.dart';
import 'package:habit_tracker/ui/components/daily_summary_card.dart';
import 'package:habit_tracker/ui/components/timeline_view.dart';
import 'package:habit_tracker/ui/components/win_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('The Daily Win')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailySummaryCard(
                completedTasks: 1,
                totalTasks: 1,
                date: "2024/15/20",
              ),
              TimelineView(
                selectedDate: selectedDate.value,
                onSelectedDateChanged: (date) => selectedDate.value = date,
              ),
              ref
                  .watch(dailySummaryProvider(selectedDate.value))
                  .when(
                    data: (data) {
                      return DailySummaryCard(
                        completedTasks: data.$1,
                        totalTasks: data.$2,
                        date: selectedDate.value.toIso8601String(),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (error, _) => Text(error.toString()),
                  ),

              winList(selectedDate: DateTime.now()),
            ],
          ),
        ),
      ),
    );
  }
}
