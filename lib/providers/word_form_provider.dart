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
