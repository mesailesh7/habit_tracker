import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.date,
  });

  final int completedTasks;
  final int totalTasks;
  final String date;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    print("From daily summary card: ${progress}");

    return Card(
      shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daily Wins",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.inversePrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        color: colorScheme.inversePrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 24,
                      backgroundColor: colorScheme.surface.withValues(
                        alpha: 0.2,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.surface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "${totalTasks > 0 ? ((completedTasks / totalTasks) * 100).toInt() : 0}% wins",
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    totalTasks > 0
                        ? completedTasks == totalTasks
                              ? Icons.check_box
                              : Icons.check_circle_outline_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "$completedTasks / $totalTasks tasks completed",
                    style: TextStyle(
                      color: colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // child: ,
      ),
    );
  }
}
