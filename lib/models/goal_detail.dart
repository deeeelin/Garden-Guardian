class GoalDetail {
  const GoalDetail({
    required this.id,
    required this.goal,
    required this.title,
    required this.total,
    this.done = false,
    this.date
  });

  final String id;
  final String goal;
  final String title;
  final int total;
  final bool done;
  final DateTime? date;
}