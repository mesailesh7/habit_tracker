import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/components/win_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:habit_tracker/data/providers/wins_for_date_provider.dart';

class winList extends HookConsumerWidget {
  const winList({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final winsAsync = ref.watch(winForDateProvider(selectedDate));
    return winsAsync.when(
      data: (wins) {
        return Expanded(
          child: ListView.separated(
            itemCount: wins.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final winWithCompletion = wins[index];
              return winCard(
                title: winWithCompletion.win.title,
                streak: winWithCompletion.win.streak,
                progress: winWithCompletion.isCompleted ? 1 : 0,
                habitId: winWithCompletion.win.id,
                isCompleted: winWithCompletion.isCompleted,
                date: selectedDate,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text("Error: error happened"),
    );
  }
}
