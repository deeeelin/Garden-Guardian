import 'package:flutter/material.dart';
import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/views/goal/goal_detail_item.dart';

class GoalDetailsPage extends StatelessWidget {
  const GoalDetailsPage({
    super.key,
    required this.goalId,
  });

  final String goalId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 93, 176, 117),
        title: Text(
          dummyGoals[goalId]!.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.green[50],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          for (final goaldetail in dummyGoals[goalId]!.goaldetails.values)
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GoalDetailItem(
                goaldetail: goaldetail,
              ),
            ),
        ],
      ),
    );
  }
}
