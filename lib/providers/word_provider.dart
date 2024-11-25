import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/word_controller.dart';
import '../models/word.dart';

class WordProvider with ChangeNotifier {
  final WordController _controller = WordController();
  List<Word> _words = [];
  String _searchQuery = '';
  String selectedTag = 'All';
  Word? _selectedWord;
  Word? _wordOfTheDay;
  bool _isLoading = false;
  String? _error;
  String? _lastFetchedDate;
  List<Word> _todaysWords = [];

  WordProvider() {
    getWords();
    loadTodaysWords();
  }

  // Getters
  List<Word> get words => _words;
  Word? get selectedWord => _selectedWord;
  Word? get wordOfTheDay => _wordOfTheDay;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Word> get todaysWords => _todaysWords;

  Future<void> fetchWordOfTheDay() async {
    final currentDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); // Get current date in 'yyyy-MM-dd' format
    final prefs = await SharedPreferences.getInstance();
    _lastFetchedDate = prefs.getString('lastFetchedDate');

    // If today's word is already fetched, no need to fetch it again
    if (_lastFetchedDate == currentDate && _wordOfTheDay != null) {
      return; // Word for today is already fetched, no need to fetch again
    }
    _isLoading = true;
    notifyListeners();

    try {
      _wordOfTheDay = await _controller.getRandomWord();

      // Store the fetched word and the current date
      await prefs.setString('lastFetchedDate', currentDate);
      await prefs.setString(
          'word',
          _wordOfTheDay?.word ??
              ""); // Store word (you can store more data if necessary)
    } catch (e) {
      print(e); // Handle error here
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTodaysWords({int limit = 3}) async {
    _setLoading(true);
    try {
      _controller.getTodaysWords(limit).listen(
        (words) {
          _todaysWords = words;
          notifyListeners();
        },
        onError: (e) {
          _setError(e.toString());
        },
      );
    } finally {
      _setLoading(false);
    }
  }

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

  // clear the selected word
  void clearSelectedWord() {
    _selectedWord = null;
    notifyListeners();
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
  List<Word> filterByTags(List<String> tags) {
    return _words
        .where((word) => tags.every((tag) => word.details!.tags.contains(tag)))
        .toList();
  }

  List<Word> searchWords() {
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
    _controller.getWords().listen(
      (words) {
        _words = words;
        notifyListeners();
      },
    );
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
