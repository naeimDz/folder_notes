import 'package:flutter/foundation.dart';
import 'package:my_lab/models/word_details.dart';

import '../models/word.dart';

class WordFormProvider extends ChangeNotifier {
  WordFormState _state = WordFormState();

  WordFormState get state => _state;
  Word get _currentWord => _state.wordData ?? Word.empty();
  WordDetails get _currentDetails => _state.wordDetails ?? WordDetails.empty();
  int get maxSteps => 3;

  void updateStep(int step) {
    if (_state.currentStep != step) {
      _state = _state.copyWith(currentStep: step);
      notifyListeners();
    }
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
    _handleNavigation(isForward: true);
  }

  // Backward navigation
  void navigateBackward() {
    _handleNavigation(isForward: false);
  }

  void updateWord(String word) {
    final currentWord = state.wordData ?? Word.empty();
    final updatedWord = currentWord.copyWith(word: word);
    _updateWordData(updatedWord);
  }

  void updateTranslation(String translation) {
    final updatedWord = _currentWord.copyWith(translation: translation);
    _updateWordData(updatedWord);
  }

  void updatePronunciation(String pronunciation) {
    final updatedWord = _currentWord.copyWith(pronunciation: pronunciation);
    _updateWordData(updatedWord);
  }

  void updateDetailWord({
    String? usageNote,
    List<String>? synonyms,
    List<String>? antonyms,
    List<String>? examples,
    List<String>? definition,
  }) {
    final updatedDetails = _currentDetails.copyWith(
      synonyms: synonyms ?? _currentDetails.synonyms,
      antonyms: antonyms ?? _currentDetails.antonyms,
      examples: examples ?? _currentDetails.examples,
      definition: definition ?? _currentDetails.definition,
      usageNotes: usageNote ?? _currentDetails.usageNotes,
    );
    if (updatedDetails != _currentDetails) {
      _state = _state.copyWith(
        wordDetails: updatedDetails,
        wordData: _currentWord.copyWith(details: updatedDetails),
      );
    }

    notifyListeners();
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

  void _setError(String? error) {
    _state = _state.copyWith(error: error);
    notifyListeners();
  }

  void reset({bool resetAll = true}) {
    if (resetAll) {
      _state = WordFormState();
    } else {
      _state = _state.copyWith(
        currentStep: 0,
        wordData: null,
        wordDetails: null,
      );
    }
    notifyListeners();
  }
}

///////////////////////
class WordFormState {
  final int currentStep;
  final Word? wordData;
  final WordDetails? wordDetails;
  final bool isLoading;
  final String? error;
  final Map<int, bool> completedSteps;

  WordFormState({
    this.currentStep = 0,
    this.wordData,
    this.wordDetails,
    this.isLoading = false,
    this.error,
    this.completedSteps = const {},
  });

  WordFormState copyWith({
    int? currentStep,
    WordDetails? wordDetails,
    Word? wordData,
    bool? isLoading,
    String? error,
    Map<int, bool>? completedSteps,
  }) {
    return WordFormState(
      currentStep: currentStep ?? this.currentStep,
      wordData: wordData ?? this.wordData,
      wordDetails: wordDetails ?? this.wordDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }
}
