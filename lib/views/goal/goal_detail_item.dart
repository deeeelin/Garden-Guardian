import 'package:flutter/material.dart';
import 'package:flutter_app/models/goal_detail.dart';
import 'package:flutter_app/data/dummy_data.dart';

class GoalDetailItem extends StatelessWidget {
  const GoalDetailItem({super.key, required this.goaldetail});

  final GoalDetail goaldetail;

  @override
  Widget build(BuildContext context) {
    final goal = dummyGoals[goaldetail.goal];
    if (goal == null) {
      return SizedBox.shrink();
    }

    // Clamp the progress to not exceed the total
    final progress = goal.progress.clamp(0, goaldetail.total).toDouble();
    final progressPercentage = progress / goaldetail.total;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(goal.icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goaldetail.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    value: progressPercentage,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text('${progress.toInt()}/${goaldetail.total}'),
          ],
        ),
      ),
    );
  }
}
