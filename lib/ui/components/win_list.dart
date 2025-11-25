import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/components/win_card.dart';

class winList extends StatelessWidget {
  const winList({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return winCard(
            title: 'Win $index',
            streak: 10,
            progress: 0,
            habitId: index,
            isCompleted: index % 2 == 0,
            date: selectedDate,
          );
        },
      ),
    );
  }
}
