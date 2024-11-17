import 'package:flutter/foundation.dart';
import 'package:my_lab/models/word_details.dart';

import '../models/word.dart';

class WordFormProvider extends ChangeNotifier {
  WordFormState _state = WordFormState();

  WordFormState get state => _state;

  void updateStep(int step) {
    _state = _state.copyWith(currentStep: step);
    notifyListeners();
  }

  void updateStepIfNeeded(int step) {
    if (_state.currentStep != step) {
      _state = _state.copyWith(currentStep: step);
      notifyListeners();
    }
  }

  // Handle the navigation based on the step
  void _handleNavigation({required bool isForward}) {
    final currentStep = _state.currentStep;

    if (isForward) {
      if (currentStep < 3 - 1) {
        final nextStep = currentStep + 1;
        updateStep(nextStep);
      }
    } else {
      if (currentStep > 0) {
        final previousStep = currentStep - 1;
        updateStep(previousStep);
      }
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
    final currentWord = _state.wordData ?? Word.empty();
    final updatedWord = currentWord.copyWith(translation: translation);
    _updateWordData(updatedWord);
  }

  void updatePronunciation(String pronunciation) {
    final currentWord = _state.wordData ?? Word.empty();
    final updatedWord = currentWord.copyWith(pronunciation: pronunciation);
    _updateWordData(updatedWord);
  }

  // Private Helper Methods
  void _updateWordData(Word updatedWord) {
    _state = _state.copyWith(wordData: updatedWord);
    notifyListeners();
  }

  // Form Completion
  Map<String, dynamic>? getFormData() {
    return _state.wordData?.toFirestore();
  }

  // Form Completion
  Word? getWordData() {
    return _state.wordData;
  }

  void reset() {
    _state = WordFormState();
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
