class WordCardConfig {
  final bool showDefinition;
  final bool showTranslation;
  final bool showMasteryScore;
  final bool showTags;
  final bool enableSlideActions;

  const WordCardConfig({
    this.showDefinition = true,
    this.showTranslation = true,
    this.showMasteryScore = false,
    this.showTags = true,
    this.enableSlideActions = true,
  });
}
