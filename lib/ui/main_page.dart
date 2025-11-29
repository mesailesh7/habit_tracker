import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/data/providers/daily_summary_provider.dart';
import 'package:habit_tracker/ui/components/daily_summary_card.dart';
import 'package:habit_tracker/ui/components/timeline_view.dart';
import 'package:habit_tracker/ui/components/win_list.dart';
import 'package:habit_tracker/ui/pages/create_win_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('The Daily Win')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ref
                  .watch(dailySummaryProvider(selectedDate.value))
                  .when(
                    data: (data) {
                      return DailySummaryCard(
                        completedTasks: data.$1,
                        totalTasks: data.$2,
                        date: DateFormat(
                          'dd-MMM-yyyy',
                        ).format(selectedDate.value),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (error, _) => Text(error.toString()),
                  ),
              TimelineView(
                selectedDate: selectedDate.value,
                onSelectedDateChanged: (date) => selectedDate.value = date,
              ),

              winList(selectedDate: DateTime.now()),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => CreateWinPage())),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Text(
                "Create Habit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
