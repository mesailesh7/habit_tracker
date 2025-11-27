import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class winCard extends HookConsumerWidget {
  const winCard({
    super.key,
    required this.title,
    required this.streak,
    required this.progress,
    required this.habitId,
    required this.isCompleted,
    required this.date,
  });

  final String title;
  final int streak;
  final double progress;
  final int habitId;
  final bool isCompleted;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // : implement build
    final colorSchema = Theme.of(context).colorScheme;

    Future<void> onComplete() async {}

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: colorSchema.onSurface),
        gradient: LinearGradient(
          colors: [
            isCompleted ? colorSchema.primary : colorSchema.secondary,
            isCompleted ? colorSchema.secondary : colorSchema.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [BoxShadow(color: colorSchema.shadow, blurRadius: 10)],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (streak > 0) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.local_activity,
                            color: colorSchema.surface,
                            size: 20.0,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Streak : $streak",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: isCompleted
                      ? LinearGradient(
                          colors: [colorSchema.primary, colorSchema.secondary],
                        )
                      : null,
                  color: isCompleted ? colorSchema.surfaceContainerHigh : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onComplete,
                    borderRadius: BorderRadius.circular(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isCompleted
                            ? colorSchema.onPrimary
                            : colorSchema.onSurfaceVariant,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
