import 'package:cloud_firestore/cloud_firestore.dart';
import 'validation_exception.dart';
import 'word_details.dart';

enum Difficulty { beginner, intermediate, advanced, expert }

enum ReviewStatus { newAdded, learning, reviewing, mastered }

class Word {
  final String? id;
  final String word;
  final String translation;
  final String definition;
  final DateTime dateAdded;
  final DateTime? lastReviewed;
  final bool isFavorite;
  final String? pronunciation;
  final List<String> examples;
  final Difficulty difficulty;
  final List<String> tags;
  final double masteryScore;
  final ReviewStatus reviewStatus;
  final WordDetails? details;

  Word({
    this.id,
    required this.word,
    required this.translation,
    required this.definition,
    required this.dateAdded,
    this.pronunciation = "",
    this.lastReviewed,
    this.isFavorite = false,
    this.examples = const [],
    this.difficulty = Difficulty.beginner,
    this.tags = const [],
    this.masteryScore = 0.0,
    this.reviewStatus = ReviewStatus.newAdded,
    this.details,
  });

  Word copyWith({
    String? id,
    String? word,
    String? translation,
    String? pronunciation,
    String? definition,
    DateTime? dateAdded,
    DateTime? lastReviewed,
    bool? isFavorite,
    List<String>? examples,
    Difficulty? difficulty,
    List<String>? tags,
    double? masteryScore,
    ReviewStatus? reviewStatus,
    WordDetails? details,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      pronunciation: pronunciation ?? this.pronunciation,
      definition: definition ?? this.definition,
      dateAdded: dateAdded ?? this.dateAdded,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      isFavorite: isFavorite ?? this.isFavorite,
      examples: examples ?? this.examples,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      masteryScore: masteryScore ?? this.masteryScore,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      details: details ?? this.details,
    );
  }

  // Validation method
  void validate() {
    if (word.isEmpty) {
      throw ValidationException('Word cannot be empty');
    }
    if (translation.isEmpty) {
      throw ValidationException('Translation cannot be empty');
    }

    // Validate details if present
    details?.validate();
  }

  // Firebase serialization
  Map<String, dynamic> toFirestore() {
    validate(); // Validate before saving

    return {
      'word': word,
      'translation': translation,
      'pronunciation': pronunciation,
      'definition': definition,
      'dateAdded': Timestamp.fromDate(dateAdded),
      'lastReviewed':
          lastReviewed != null ? Timestamp.fromDate(lastReviewed!) : null,
      'isFavorite': isFavorite,
      'examples': examples,
      'difficulty': difficulty.toString(),
      'tags': tags,
      'masteryScore': masteryScore,
      'reviewStatus': reviewStatus.toString(),
      'details': details?.toFirestore(),
    };
  }

  factory Word.empty() {
    return Word(
        id: "id",
        word: "word",
        translation: "translation",
        definition: "definition",
        pronunciation: "pronunciation",
        details: WordDetails.empty(),
        dateAdded: DateTime.now());
  }

  // Factory constructor from Firestore
  factory Word.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final word = Word(
      id: doc.id,
      word: data['word'] ?? '',
      translation: data['translation'] ?? '',
      pronunciation: data['pronunciation'] ?? '',
      definition: data['definition'] ?? '',
      dateAdded: (data['dateAdded'] as Timestamp).toDate(),
      lastReviewed: data['lastReviewed'] != null
          ? (data['lastReviewed'] as Timestamp).toDate()
          : null,
      isFavorite: data['isFavorite'] ?? false,
      examples: List<String>.from(data['examples'] ?? []),
      difficulty: Difficulty.values.firstWhere(
        (e) => e.toString() == data['difficulty'],
        orElse: () => Difficulty.beginner,
      ),
      tags: List<String>.from(data['tags'] ?? []),
      masteryScore: (data['masteryScore'] ?? 0.0).toDouble(),
      reviewStatus: ReviewStatus.values.firstWhere(
        (e) => e.toString() == data['reviewStatus'],
        orElse: () => ReviewStatus.newAdded,
      ),
      details: data['details'] != null
          ? WordDetails.fromFirestore(data['details'])
          : null,
    );

    word.validate(); // Validate after loading
    return word;
  }
}
