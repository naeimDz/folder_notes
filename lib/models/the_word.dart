import 'package:cloud_firestore/cloud_firestore.dart';

enum Difficulty { beginner, intermediate, advanced, expert }

enum ReviewStatus { newAdded, learning, reviewing, mastered }

class TheWord {
  final String? id;
  final DateTime dateAdded;
  final String word;
  final String translation;
  final String pronunciation;
  final List<String>? definitions;
  final List<String>? examples;
  final String? contextNotes;
  final List<String>? lexicalRelations;
  final List<String>? synonyms;
  final List<String>? antonyms;
  final List<String>? tags;
  final bool isFavorite;

  final String? audioUrl;
  final String? imageUrl;
  final double masteryScore;
  final Difficulty difficulty;
  final ReviewStatus reviewStatus;

  TheWord({
    this.id,
    required this.dateAdded,
    required this.word,
    required this.translation,
    required this.pronunciation,
    this.definitions,
    this.examples,
    this.contextNotes,
    this.lexicalRelations,
    this.antonyms,
    this.synonyms,
    this.tags,
    this.isFavorite = false,
    this.audioUrl,
    this.imageUrl,
    this.masteryScore = 0.0,
    this.difficulty = Difficulty.beginner,
    this.reviewStatus = ReviewStatus.newAdded,
  });
  TheWord copyWith({
    String? id,
    DateTime? dateAdded,
    String? word,
    String? translation,
    String? pronunciation,
    List<String>? definitions,
    List<String>? examples,
    String? contextNotes,
    List<String>? lexicalRelations,
    List<String>? synonyms,
    List<String>? antonyms,
    List<String>? tags,
    bool? isFavorite,
    String? audioUrl,
    String? imageUrl,
    double? masteryScore,
    Difficulty? difficulty,
    ReviewStatus? reviewStatus,
  }) {
    return TheWord(
      id: id ?? this.id,
      dateAdded: dateAdded ?? this.dateAdded,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      pronunciation: pronunciation ?? this.pronunciation,
      definitions: definitions ?? this.definitions,
      examples: examples ?? this.examples,
      contextNotes: contextNotes ?? this.contextNotes,
      lexicalRelations: lexicalRelations ?? this.lexicalRelations,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      masteryScore: masteryScore ?? this.masteryScore,
      difficulty: difficulty ?? this.difficulty,
      reviewStatus: reviewStatus ?? this.reviewStatus,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'dateAdded': Timestamp.fromDate(dateAdded),
      'word': word,
      'translation': translation,
      'pronunciation': pronunciation,
      'definitions': definitions ?? [],
      'examples': examples ?? [],
      'contextNotes': contextNotes,
      'lexicalRelations': lexicalRelations ?? [],
      'synonyms': synonyms ?? [],
      'antonyms': antonyms ?? [],
      'tags': tags ?? [],
      'isFavorite': isFavorite,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'masteryScore': masteryScore,
      'difficulty':
          difficulty.toString().split('.').last, // Store enum as string
      'reviewStatus':
          reviewStatus.toString().split('.').last, // Store enum as string
    };
  }

  // Deserialize from Firestore data
  factory TheWord.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      return TheWord(
        id: doc.id,
        dateAdded: (data['dateAdded'] as Timestamp).toDate(),
        word: data['word'] ?? '',
        translation: data['translation'] ?? '',
        pronunciation: data['pronunciation'] ?? '',
        definitions: List<String>.from(data['definitions'] ?? []),
        examples: List<String>.from(data['examples'] ?? []),
        contextNotes: data['contextNotes'],
        lexicalRelations: List<String>.from(data['lexicalRelations'] ?? []),
        synonyms: List<String>.from(data['synonyms'] ?? []),
        antonyms: List<String>.from(data['antonyms'] ?? []),
        tags: List<String>.from(data['tags'] ?? []),
        isFavorite: data['isFavorite'] ?? false,
        audioUrl: data['audioUrl'],
        imageUrl: data['imageUrl'],
        masteryScore: data['masteryScore']?.toDouble() ?? 0.0,
        difficulty: Difficulty.values.firstWhere(
            (e) => e.toString().split('.').last == data['difficulty'],
            orElse: () => Difficulty.beginner),
        reviewStatus: ReviewStatus.values.firstWhere(
            (e) => e.toString().split('.').last == data['reviewStatus'],
            orElse: () => ReviewStatus.newAdded),
      );
    } catch (e) {
      throw FormatException('Error parsing TheWord data from Firestore: $e');
    }
  }

  factory TheWord.empty() {
    return TheWord(
      dateAdded: DateTime.now(),
      word: "",
      translation: "",
      pronunciation: "",
    );
  }
}
