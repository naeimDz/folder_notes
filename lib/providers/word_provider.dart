import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/word_controller.dart';
import '../models/word.dart';

class WordProvider with ChangeNotifier {
  final WordController _controller = WordController();
  List<Word> _words = [];
  String _searchQuery = '';
  Word? _selectedWord;
  Word? _wordOfTheDay;
  bool _isLoading = false;
  String? _error;
  String? _lastFetchedDate;
  List<Word> _todaysWords = [];
  bool updateSelectedWord = false;

  WordProvider() {
    getWords();
    loadTodaysWords();
    fetchWordOfTheDay();
  }

  // Getters
  // List<Word> get words => _words;
  List<Word> get words {
    if (_searchQuery.isEmpty) {
      return _words;
    }
    return _words
        .where((word) =>
            word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            word.translation.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

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
    setLoading(_isLoading);

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

    setLoading(_isLoading);
  }

  Future<void> loadTodaysWords({int limit = 3}) async {
    setLoading(true);
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
      setLoading(false);
    }
  }

  // CRUD Operations
  Future<void> addWord(Word word) async {
    setLoading(true);
    try {
      await _controller.addWord(word);

      _words.add(word);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

// Toggle favorite status
  Future<void> toggleFavorite(String wordId) async {
    try {
      final word = _words.firstWhere((word) => word.id == wordId);
      await _controller.updateField(
        documentId: word.id!,
        fieldPath: 'isFavorite',
        value: !word.isFavorite,
      );
      notifyListeners();
    } catch (e) {
      print("Error toggling favorite status: $e");
    }
  }

  // Delete a word

  Future<void> deleteWord(String id) async {
    setLoading(true);
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
      setLoading(false);
    }
  }

  // Words after applying the filter
  List<Word> getFilteredWords(String selectedFilter) {
    switch (selectedFilter) {
      case 'Favorites':
        return _words.where((word) => word.isFavorite).toList();
      case 'Recent':
        return _words;
      case 'Mastered':
        return _words;
      case 'Alphabetical':
        return _words..sort((a, b) => a.word.compareTo(b.word));
      case 'Mastery Level':
        return _words..sort((a, b) => b.masteryScore.compareTo(a.masteryScore));
      default: // 'All Words'
        return _words;
    }
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

  // Method to update the word list
  void updateWords(List<Word> words) {
    _words = words
        .where((word) =>
            word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            word.translation.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    notifyListeners(); // Notify listeners to rebuild UI
  }

  void setLoading(bool loading) {
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
