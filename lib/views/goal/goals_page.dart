import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/goal.dart';
import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/views/goal/goal_item.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/authentication.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  Map<String, Goal> goals = dummyGoals;

  @override
  void initState() {
    super.initState();
    _fetchUserGoals();
  }

  Future<void> _fetchUserGoals() async {
    final userId = 'cV8dyoEmSUZo7QXUiceE1g4YvLm1'; //! [TODO] Replace with the actual user ID
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      setState(() {
        goals['g1']?.progress = data['cnt_signin'] ?? 0;
        goals['g2']?.progress = data['cnt_plantNum'] ?? 0;
        goals['g3']?.progress = data['cnt_plantType'] ?? 0;
        goals['g4']?.progress = data['cnt_watering'] ?? 0;
        goals['g5']?.progress = data['cnt_drink'] ?? 0;
      });
    }
  }

  void _selectGoal(BuildContext context, Goal goal) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goGoalDetailsOnCategory(goalId: goal.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 93, 176, 117),
        title: Text(
          "Achievement",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.green[50],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: goals.values.map((goal) {
          return AnimatedContainer(
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
            child: GoalItem(
              goal: goal,
              onSelectGoal: () {
                _selectGoal(context, goal);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
