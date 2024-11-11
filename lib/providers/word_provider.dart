import 'package:flutter/foundation.dart';

import '../controller/word_controller.dart';
import '../models/word.dart';

class WordProvider with ChangeNotifier {
  final WordController _controller = WordController();
  List<Word> _words = [];
  String _searchQuery = '';
  String selectedTag = 'All';
  Word? _selectedWord;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Word> get words => _words;
  Word? get selectedWord => _selectedWord;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // CRUD Operations
  Future<void> addWord(Word word) async {
    _setLoading(true);
    try {
      await _controller.addWord(word);
      _words.add(word);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateWord(Word word) async {
    _setLoading(true);
    try {
      await _controller.updateWord(word);
      final index = _words.indexWhere((w) => w.id == word.id);
      if (index != -1) {
        _words[index] = word;
        if (_selectedWord?.id == word.id) {
          _selectedWord = word;
        }
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteWord(String id) async {
    _setLoading(true);
    try {
      await _controller.deleteWord(id);
      _words.removeWhere((w) => w.id == id);
      if (_selectedWord?.id == id) {
        _selectedWord = null;
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Selection
  void selectWord(Word? word) {
    _selectedWord = word;
    notifyListeners();
  }

  // Custom Property Operations
  Future<void> addCustomProperty(
    String wordId,
    String name,
    dynamic value,
    String type,
  ) async {
    final wordIndex = _words.indexWhere((w) => w.id == wordId);
    if (wordIndex == -1) return;

    final updatedWord = _words[wordIndex].addCustomProperty(name, value, type);
    await updateWord(updatedWord);
  }

  // Filter Operations
  Future<void> loadFavorites() async {
    _setLoading(true);
    try {
      _controller.getFavoriteWords().listen(
        (favorites) {
          _words = favorites;
          notifyListeners();
        },
        onError: (e) => _setError(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadByDifficulty(Difficulty difficulty) async {
    _setLoading(true);
    try {
      _controller.getWordsByDifficulty(difficulty).listen(
        (words) {
          _words = words;
          notifyListeners();
        },
        onError: (e) => _setError(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadForReview() async {
    _setLoading(true);
    try {
      _controller.getWordsForReview().listen(
        (words) {
          _words = words;
          notifyListeners();
        },
        onError: (e) => _setError(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Search and filter methods
  List<Word> searchWords(String query) {
    return _words
        .where((word) =>
            word.word.toLowerCase().contains(query.toLowerCase()) ||
            word.translation.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Word> filterByTags(List<String> tags) {
    return _words
        .where((word) => tags.every((tag) => word.tags.contains(tag)))
        .toList();
  }

  List<Word> filterWords() {
    return _words
        .where((word) =>
            word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            word.translation.toLowerCase().contains(_searchQuery.toLowerCase()))
        /* .where((word) =>
          tags.every((tag) => word.tags.contains(tag)))*/
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Load words from Firebase
  Future<void> getWords() async {
    _setLoading(true);
    try {
      _controller.getWordsForReview().listen(
        (words) {
          _words = words;
          notifyListeners();
        },
        onError: (e) => _setError(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Helper Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
