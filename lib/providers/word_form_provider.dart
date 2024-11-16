import 'package:flutter/foundation.dart';

import '../models/word.dart';

class WordFormProvider extends ChangeNotifier {
  WordFormState _state = WordFormState();

  WordFormState get state => _state;

  void updateStep(int step) {
    _state = _state.copyWith(currentStep: step);
    notifyListeners();
  }
}

class WordFormState {
  final int currentStep;
  final Word? wordData;
  final bool isLoading;
  final String? error;
  final Map<int, bool> completedSteps;

  WordFormState({
    this.currentStep = 0,
    this.wordData,
    this.isLoading = false,
    this.error,
    this.completedSteps = const {},
  });

  WordFormState copyWith({
    int? currentStep,
    Word? wordData,
    bool? isLoading,
    String? error,
    Map<int, bool>? completedSteps,
  }) {
    return WordFormState(
      currentStep: currentStep ?? this.currentStep,
      wordData: wordData ?? this.wordData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }
}
