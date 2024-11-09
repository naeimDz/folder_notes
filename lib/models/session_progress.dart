import 'practice_response.dart';

class SessionProgress {
  int currentWordIndex;
  double sessionProgress;
  List<PracticeResponse> responses;

  SessionProgress({
    required this.currentWordIndex,
    required this.sessionProgress,
    required this.responses,
  });

  void addResponse(PracticeResponse response) {
    responses.add(response);
    sessionProgress = (currentWordIndex + 1) / responses.length * 100;
    currentWordIndex++;
  }
}
