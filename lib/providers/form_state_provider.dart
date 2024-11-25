import 'package:flutter/foundation.dart';
import 'package:my_lab/models/the_word.dart';

import '../models/word_form_state.dart';

class FormStateProvider with ChangeNotifier {
  WordFormState _state = WordFormState();
  WordFormState get state => _state;
  TheWord get _currentWord => _state.theWord ?? TheWord.empty();

  int get maxSteps => 3;

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
      word: word ?? _state.theWord?.word,
      translation: translation ?? _state.theWord?.translation,
      pronunciation: pronunciation ?? _state.theWord?.pronunciation,
    );

    if (updatedWord != _currentWord) {
      _state = _state.copyWith(theWord: updatedWord);
      notifyListeners();
    }
  }

  void updateTheWordDetail({
    String? contextNotes,
    List<String>? synonyms,
    List<String>? antonyms,
    List<String>? examples,
    List<String>? definitions,
  }) {
    final updatedDetails = _currentWord.copyWith(
      synonyms: synonyms ?? _currentWord.synonyms,
      antonyms: antonyms ?? _currentWord.antonyms,
      examples: examples ?? _currentWord.examples,
      definitions: definitions ?? _currentWord.definitions,
      contextNotes: contextNotes ?? _currentWord.contextNotes,
    );
    if (updatedDetails != _currentWord) {
      _state = _state.copyWith(
        theWord: updatedDetails,
      );
    }

    notifyListeners();
  }

  // Private Helper Methods
  void _updateWordData(TheWord updatedWord) {
    _state = _state.copyWith(theWord: updatedWord);
    notifyListeners();
  }

  // Form Completion
  TheWord? getWordData() {
    return _currentWord;
  }

  void reset({bool resetAll = true}) {
    if (resetAll) {
      _state = WordFormState();
    } else {
      _state = _state.copyWith(
        currentStep: 0,
        wordDetails: null,
      );
    }
    notifyListeners();
  }
}
