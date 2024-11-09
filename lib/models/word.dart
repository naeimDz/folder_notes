class Word {
  final int id;
  final String word;
  final String translation;
  final String definition;
  final String context;
  final String lastReviewed;
  final String difficulty;
  final String nextReview;
  final List<String> synonyms;
  double mastery;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    required this.definition,
    required this.context,
    required this.lastReviewed,
    required this.difficulty,
    required this.nextReview,
    required this.synonyms,
    this.mastery = 0.0,
  });

  // Add any methods for updating mastery, calculating next review time, etc.
}
