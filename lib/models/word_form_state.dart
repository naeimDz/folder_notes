import 'word.dart';
import 'word_details.dart';

class WordFormState {
  final int currentStep;
  final bool isLastStep;
  final Word? wordData;
  final WordDetails? wordDetails;
  final bool isLoading;
  final String? error;
  final Map<int, bool> completedSteps;

  WordFormState({
    this.currentStep = 0,
    this.isLastStep = false,
    this.wordData,
    this.wordDetails,
    this.isLoading = false,
    this.error,
    this.completedSteps = const {},
  });

  WordFormState copyWith({
    int? currentStep,
    bool? isLastStep,
    WordDetails? wordDetails,
    Word? wordData,
    bool? isLoading,
    String? error,
    Map<int, bool>? completedSteps,
  }) {
    return WordFormState(
      currentStep: currentStep ?? this.currentStep,
      isLastStep: isLastStep ?? this.isLastStep,
      wordData: wordData ?? this.wordData,
      wordDetails: wordDetails ?? this.wordDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }

  factory WordFormState.empty() {
    return WordFormState(
      currentStep: 0,
      error: "",
      isLastStep: false,
      isLoading: false,
    );
  }
}
