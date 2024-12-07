import 'package:flutter/foundation.dart';

import '../controller/word_controller.dart';
import '../models/word.dart';
import '../models/word_form_state.dart';

class FormStateProvider with ChangeNotifier {
  final WordController _controller = WordController();

  WordFormState _state = WordFormState();
  WordFormState get state => _state;
  Word get _currentWord => _state.wordData ?? Word.empty();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int get maxSteps => 3;

  // Selection
  void selectWord(Word? word) {
    _state = _state.copyWith(wordData: word, wordDetails: word?.details);
    notifyListeners();
  }

  Future<void> updateRelatedWord({
    required String documentId,
    List<String>? synonyms,
    List<String>? antonyms,
    bool isArrayUnion = false,
    bool isArrayRemove = false,
  }) async {
    String fieldPath = "synonyms";

    if (synonyms != null) {
      fieldPath = 'synonyms';
    } else if (antonyms != null) {
      fieldPath = 'antonyms';
    }
    await _controller.updateField(
      documentId: documentId,
      fieldPath: fieldPath,
      value: synonyms ?? antonyms,
      isArrayUnion: isArrayUnion,
      isArrayRemove: isArrayRemove,
    );
    final updatedWord =
        _currentWord.details?.copyWith(antonyms: antonyms, synonyms: synonyms);
    if (updatedWord != _currentWord.details) {
      _updateWordData(_currentWord.copyWith(details: updatedWord));
      notifyListeners();
    }
  }

  Future<void> updateTheWord(Word word) async {
    await _controller.updateWord(word);
  }

  // Handle the navigation based on the step
  void _handleNavigation({required bool isForward}) {
    final newStep = _state.currentStep + (isForward ? 1 : -1);
    if (newStep >= 0 && newStep < maxSteps) {
      updateStep(newStep);
    }
  }

  // Forward navigation

  void navigateForward() {
    if (canNavigateForward()) {
      _handleNavigation(isForward: true);
    }
  }

  bool canNavigateForward() {
    if (_state.currentStep == 0) {
      // Validate first step
      if (_currentWord.word.isEmpty ||
          _currentWord.translation.isEmpty ||
          _currentWord.pronunciation.isEmpty) {
        return false; // Prevent navigation
      }
    }
    updateCoreWord();

    return true; // Placeholder
  }

  // Backward navigation
  void navigateBackward() {
    if (_state.currentStep > 0) _handleNavigation(isForward: false);
  }

  void updateStep(int step) {
    if (_state.currentStep != step) {
      _state = _state.copyWith(currentStep: step, isLastStep: false);
      if (_state.currentStep == 2) {
        _state = _state.copyWith(isLastStep: true);
      }
    }
    notifyListeners();
  }

  void updateCoreWord(
      {String? word, String? translation, String? pronunciation}) {
    final updatedWord = _currentWord.copyWith(
      word: word ?? _currentWord.word,
      translation: translation ?? _currentWord.translation,
      pronunciation: pronunciation ?? _currentWord.pronunciation,
    );

    if (updatedWord != _currentWord) {
      _state = _state.copyWith(wordData: updatedWord);
      notifyListeners();
    }
  }

  void updateTheWordDetail({
    String? contextNotes,
    List<String>? synonyms,
    List<String>? antonyms,
    List<String>? tags,
    String? example,
    String? definition,
  }) {
    final updatedWord = _currentWord.details?.copyWith(
      synonyms: synonyms ?? _currentWord.details?.synonyms,
      antonyms: antonyms ?? _currentWord.details?.antonyms,
      tags: tags ?? _currentWord.details?.tags,
      example: example ?? _currentWord.details?.example,
      definition: definition ?? _currentWord.details?.definition,
      contextNotes: contextNotes ?? _currentWord.details?.contextNotes,
    );
    if (updatedWord != _currentWord.details) {
      _updateWordData(_currentWord.copyWith(details: updatedWord));
      notifyListeners();
    }
  }

  // Private Helper Methods
  void _updateWordData(Word updatedWord) {
    _state = _state.copyWith(wordData: updatedWord);
    notifyListeners();
  }

  // Form Completion
  Word? getWordData() {
    return _currentWord;
  }

  void reset({bool resetAll = true}) {
    if (resetAll) {
      _state = WordFormState();
    } else {
      _state =
          _state.copyWith(currentStep: 0, wordDetails: null, wordData: null);
    }
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
