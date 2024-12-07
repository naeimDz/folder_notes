import 'package:flutter/material.dart';
import 'package:my_lab/screen/shared/widgets/custom_sliver_app_bar.dart';
import 'package:my_lab/screen/word_detail/learning_progress_widget.dart';
import 'package:my_lab/screen/word_detail/word_relations_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/form_state_provider.dart';
import '../../providers/word_provider.dart';

class WordDetailScreen extends StatefulWidget {
  const WordDetailScreen({super.key});

  @override
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCustomCard({
    required String title,
    required Widget child,
    Color? backgroundColor,
    EdgeInsets? padding,
    bool showIfEmpty = true,
  }) {
    if (!showIfEmpty && child is Column && (child.children.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(int? level) {
    final safeLevel = level?.clamp(0, 4) ?? 0;
    return Row(
      children: List.generate(4, (index) {
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < safeLevel ? Colors.orange : Colors.grey[300],
          ),
        );
      }),
    );
  }

  Widget _buildErrorPlaceholder({required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build WordDetailScreen //");
    final word =
        Provider.of<FormStateProvider>(context, listen: false).state.wordData;

    //context.read<FormStateProvider>().selectWord(word);
    // print(context.read<FormStateProvider>().state.wordData);
    if (word == null) {
      return Scaffold(
        body: _buildErrorPlaceholder(
          message: "Word data not found. Please try again later.",
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: word.word,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      word.translation,
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        word.pronunciation,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Play sound logic
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Colors.blue[700],
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...[
                            const SizedBox(height: 16),
                            Selector<WordProvider, int>(
                              selector: (context, provider) =>
                                  provider.selectedWord?.difficulty.index ?? 0,
                              builder: (context, difficultyIndex, child) {
                                return _buildDifficultyIndicator(
                                    difficultyIndex);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Definition Section
                  _buildCustomCard(
                    title: "Definition",
                    backgroundColor: Colors.blue[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.details?.definition ?? "",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // Examples Section
                  if (word.details!.example.isNotEmpty)
                    _buildCustomCard(
                      title: "Examples",
                      backgroundColor: Colors.green[50],
                      showIfEmpty: false,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green[100]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          word.details!.example,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  // Synonyms & Antonyms
                  Selector<FormStateProvider, (List<String>, List<String>)>(
                    selector: (context, provider) => (
                      provider.state.wordDetails?.synonyms ?? [],
                      provider.state.wordDetails?.antonyms ?? []
                    ),
                    builder: (context, theWordDetail, child) {
                      return WordRelationsWidget(
                        synonyms: theWordDetail.$1,
                        antonyms: theWordDetail.$2,
                        word: word,
                      );
                    },
                  ),

                  // Learning Progress
                  LearningProgressWidget(
                      reviewStatus: word.reviewStatus.name,
                      masteryScore: word.masteryScore),

                  // Quick Actions Section
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        _buildActionButton(
                          icon: Icons.school,
                          label: "Practice with Flashcards",
                          color: Colors.purple,
                          onPressed: () {
                            // Add to Flashcards action
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.quiz,
                          label: "Take Quick Quiz",
                          color: Colors.green,
                          onPressed: () {
                            // Start Quick Quiz action
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.record_voice_over,
                          label: "Practice Pronunciation",
                          color: Colors.blue,
                          onPressed: () {
                            // Practice pronunciation action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add to study list action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to study list'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Undo action
                },
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add to Study List'),
        backgroundColor: Colors.blue[700],
      ),
    );
  }

/////////////////////////////////////////
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add error handling widget for no data scenarios
  Widget _buildNoDataPlaceholder({required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add error handling for specific sections
  Widget Function(FlutterErrorDetails details) _buildSectionErrorHandler({
    required Widget child,
    required String fallbackMessage,
    bool showFallback = true,
  }) {
    return ErrorWidget.builder = (FlutterErrorDetails details) {
      return showFallback
          ? _buildNoDataPlaceholder(message: fallbackMessage)
          : const SizedBox.shrink();
    };
  }

  // Add method to handle safe string display
  String _getSafeString(String? value, {String fallback = ''}) {
    return value?.isNotEmpty == true ? value! : fallback;
  }
}

// Add extension method for safer null handling
extension StringExtension on String? {
  String orEmpty() => this ?? '';

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String ifEmpty(String fallback) => isNullOrEmpty ? fallback : this!;
}

// Add a custom exception class for word-related errors
class WordDetailException implements Exception {
  final String message;
  final String? code;

  WordDetailException(this.message, {this.code});

  @override
  String toString() =>
      'WordDetailException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Add mixin for error handling functionality
mixin WordErrorHandler {
  void handleError(BuildContext context, dynamic error) {
    String message;
    if (error is WordDetailException) {
      message = error.message;
    } else {
      message = 'An unexpected error occurred. Please try again.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[700],
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
