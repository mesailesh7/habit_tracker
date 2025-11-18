import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({
    super.key,
    required this.selectedDate,
    required this.onSelectedDateChanged,
  });

  final DateTime selectedDate;
  final void Function(DateTime) onSelectedDateChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return const Placeholder();
  }
}
