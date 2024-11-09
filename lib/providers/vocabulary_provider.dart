import 'package:flutter/foundation.dart';
import '../models/word.dart';

class VocabularyProvider with ChangeNotifier {
  final List<Word> _words = practiceWords;
  String _searchQuery = '';
  String selectedCategory = 'All';

  List<Word> get filteredWords {
    return _words.where((word) {
      final matchesSearch =
          word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              word.translation.contains(_searchQuery);
      final matchesCategory =
          selectedCategory == 'All' || word.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String wordId) {
    final wordIndex = _words.indexWhere((w) => w.id == wordId);
    if (wordIndex >= 0) {
      final word = _words[wordIndex];
      _words[wordIndex] = Word(
        id: word.id,
        word: word.word,
        translation: word.translation,
        pronunciation: word.pronunciation,
        definition: word.definition,
        examples: word.examples,
        synonyms: word.synonyms,
        masteryScore: word.masteryScore,
        isFavorite: !word.isFavorite,
        category: word.category,
        tags: word.tags,
        context: word.context,
        lastReviewed: word.lastReviewed,
        nextReview: word.nextReview,
        difficulty: word.difficulty,
      );
      notifyListeners();
    }
  }
}
