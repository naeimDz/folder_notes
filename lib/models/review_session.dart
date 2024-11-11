import 'package:my_lab/models/review_schedule.dart';

class ReviewSession {
  final int totalWords;
  final int dueToday;
  final int streak;
  final List<ReviewSchedule> reviewSchedule;

  ReviewSession({
    required this.totalWords,
    required this.dueToday,
    required this.streak,
    required this.reviewSchedule,
  });
}
