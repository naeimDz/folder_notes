import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/word.dart';
import '../../providers/form_state_provider.dart';
import 'word_input.dart';

class WordRelationsWidget extends StatelessWidget {
  final Word word;
  final List<String>? synonyms;
  final List<String>? antonyms;
  const WordRelationsWidget({
    super.key,
    required this.word,
    this.synonyms,
    this.antonyms,
  });

  void handleModifyWord(
    String theWord,
    String type,
    FormStateProvider provider, {
    bool isArrayUnion = true,
    bool isArrayRemove = false,
  }) {
    final documentId = word.id!;
    final synonymsList = type == 'Synonym' ? [theWord] : null;
    final antonymsList = type == 'Antonym' ? [theWord] : null;

    provider.updateRelatedWord(
      documentId: documentId,
      synonyms: synonymsList,
      antonyms: antonymsList,
      isArrayUnion: isArrayUnion,
      isArrayRemove: isArrayRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the FormStateProvider
    final provider = context.watch<FormStateProvider>();

    // UI for the WordRelationsWidget
    return Column(
      children: [
        // Show input section for adding new word
        WordInput(
          isVisible: provider.isLoading,
          onSave: (word, type) {
            handleModifyWord(word, type, provider);
            provider.setLoading(false);
          },
          onHide: () {
            provider.setLoading(false);
          },
        ),

        // Display lists for synonyms and antonyms
        Row(
          children: [
            if (synonyms!.isNotEmpty && synonyms!.first.isNotEmpty) ...[
              Expanded(
                child: _buildWordList(
                  context,
                  title: "Synonyms",
                  words: synonyms!,
                  cardColor: Colors.green[50]!,
                  chipColor: Colors.green[100]!,
                  textColor: Colors.green[900]!,
                ),
              ),
              if (antonyms!.isNotEmpty) const SizedBox(width: 16),
            ],
            if (antonyms!.isNotEmpty && antonyms!.first.isNotEmpty)
              Expanded(
                child: _buildWordList(
                  context,
                  title: "Antonyms",
                  words: antonyms!,
                  cardColor: Colors.red[50]!,
                  chipColor: Colors.red[100]!,
                  textColor: Colors.red[900]!,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildWordChip({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    VoidCallback? onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWordList(
    BuildContext context, {
    required String title,
    required List<String> words,
    required Color cardColor,
    required Color chipColor,
    required Color textColor,
  }) {
    return Container(
      color: cardColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.map((word) {
              return _buildWordChip(
                onRemove: () {
                  final provider = context.read<FormStateProvider>();
                  handleModifyWord(
                    word,
                    title.substring(0, 7), // Either "Synonym" or "Antonym"
                    provider,
                    isArrayUnion: false, // Set to false for removal
                    isArrayRemove: true,
                  );
                },
                text: word,
                backgroundColor: chipColor,
                textColor: textColor,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              // Toggle the input visibility
              context.read<FormStateProvider>().setLoading(true);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: textColor,
            ),
            label: Text(
              'Add ${title.toLowerCase()}',
              style: TextStyle(color: textColor),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: chipColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
