import 'package:cloud_firestore/cloud_firestore.dart';
import 'validation_exception.dart';
import 'word_details.dart';
import 'custom_property.dart';

enum Difficulty { beginner, intermediate, advanced, expert }

enum ReviewStatus { newAdded, learning, reviewing, mastered }

class Word {
  final String id;
  final String word;
  final String translation;
  final String definition;
  final DateTime dateAdded;
  final DateTime? lastReviewed;
  final bool isFavorite;

  final List<String> examples;
  final Difficulty difficulty;
  final List<String> tags;
  final double masteryScore;
  final ReviewStatus reviewStatus;

  final WordDetails? details;
  final Map<String, CustomProperty> customProperties;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    required this.definition,
    required this.dateAdded,
    this.lastReviewed,
    this.isFavorite = false,
    this.examples = const [],
    this.difficulty = Difficulty.beginner,
    this.tags = const [],
    this.masteryScore = 0.0,
    this.reviewStatus = ReviewStatus.newAdded,
    this.details,
    this.customProperties = const {},
  });

  // Validation method
  void validate() {
    if (word.isEmpty) {
      throw ValidationException('Word cannot be empty');
    }
    if (translation.isEmpty) {
      throw ValidationException('Translation cannot be empty');
    }
    if (definition.isEmpty) {
      throw ValidationException('Definition cannot be empty');
    }
    if (masteryScore < 0 || masteryScore > 100) {
      throw ValidationException('Mastery score must be between 0 and 100');
    }

    // Validate custom properties
    customProperties.values.forEach((prop) => prop.validate());

    // Validate details if present
    details?.validate();
  }

  // Firebase serialization
  Map<String, dynamic> toFirestore() {
    validate(); // Validate before saving

    return {
      'word': word,
      'translation': translation,
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
      'customProperties': customProperties
          .map((key, value) => MapEntry(key, value.toFirestore())),
    };
  }

  // Factory constructor from Firestore
  factory Word.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final word = Word(
      id: doc.id,
      word: data['word'] ?? '',
      translation: data['translation'] ?? '',
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
      customProperties: (data['customProperties'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    key,
                    CustomProperty.fromFirestore(value as Map<String, dynamic>),
                  )) ??
          {},
    );

    word.validate(); // Validate after loading
    return word;
  }

  // Helper method to add custom property
  Word addCustomProperty(String name, dynamic value, String type) {
    final newProperties = Map<String, CustomProperty>.from(customProperties);
    newProperties[name] = CustomProperty(name: name, value: value, type: type);

    return Word(
      id: id,
      word: word,
      translation: translation,
      definition: definition,
      dateAdded: dateAdded,
      lastReviewed: lastReviewed,
      isFavorite: isFavorite,
      examples: examples,
      difficulty: difficulty,
      tags: tags,
      masteryScore: masteryScore,
      reviewStatus: reviewStatus,
      details: details,
      customProperties: newProperties,
    );
  }
}
