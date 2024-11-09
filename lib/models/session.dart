class Session {
  final int totalWords;
  final int dueToday;
  final int streak;
  final List<Map<String, dynamic>> reviewSchedule;

  Session({
    required this.totalWords,
    required this.dueToday,
    required this.streak,
    required this.reviewSchedule,
  });
}
