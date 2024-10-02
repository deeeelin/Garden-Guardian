import 'package:flutter/material.dart';
import 'package:flutter_app/models/goal.dart';

class GoalItem extends StatelessWidget {
  const GoalItem({
    super.key,
    required this.goal,
    required this.onSelectGoal,
  });

  final Goal goal;
  final void Function() onSelectGoal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onSelectGoal,
        borderRadius: BorderRadius.circular(16),
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(goal.icon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(goal.content)
                    ]),
              ),
              const SizedBox(width: 10),
              Text('${goal.progress}/${goal.total}')
            ])));
  }
}
