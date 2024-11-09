class Word {
  final String word;
  final String translation;
  final String definition;
  final String frequency;

  Word({
    required this.word,
    required this.translation,
    required this.definition,
    required this.frequency,
  });

  // Factory constructor to create a Word object from a map
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'],
      translation: map['translation'],
      definition: map['definition'],
      frequency: map['frequency'],
    );
  }
}
