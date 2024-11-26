import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_lab/screen/word_detail/custom_section.dart';
import '../../models/word.dart';
import '../../providers/word_provider.dart';
import 'word_input.dart';

class WordRelationsWidget extends StatelessWidget {
  final Word word;

  const WordRelationsWidget({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    final synonyms = word.details?.synonyms ?? [];
    final antonyms = word.details?.antonyms ?? [];

    // Fetch the Firestore provider
    final provider = context.watch<WordProvider>();
    // Method to handle adding a new word to synonyms or antonyms
    void handleAddWord(String theWord, String type) {
      final fieldPath =
          type == 'Synonym' ? 'details.synonyms' : 'details.antonyms';
      final isArrayUnion = true; // Always adding new words, not removing

      provider.updateField(
        documentId: word.id!,
        fieldPath: fieldPath,
        value: theWord,
        isArrayUnion: isArrayUnion,
      );
    }

    // UI for the WordRelationsWidget
    return Column(
      children: [
        // Show input section for adding new word
        WordInput(
          isVisible: provider.isLoading,
          onSave: (word, type) {
            handleAddWord(word, type);
          },
          onHide: () {},
        ),

        // Display lists for synonyms and antonyms
        Row(
          children: [
            if (synonyms.isNotEmpty && synonyms.first.isNotEmpty) ...[
              Expanded(
                child: _buildWordList(
                  context,
                  title: "Synonyms",
                  words: synonyms,
                  cardColor: Colors.green[50]!,
                  chipColor: Colors.green[100]!,
                  textColor: Colors.green[900]!,
                ),
              ),
              if (antonyms.isNotEmpty) const SizedBox(width: 16),
            ],
            if (antonyms.isNotEmpty && antonyms.first.isNotEmpty)
              Expanded(
                child: _buildWordList(
                  context,
                  title: "Antonyms",
                  words: antonyms,
                  cardColor: Colors.red[50]!,
                  chipColor: Colors.red[100]!,
                  textColor: Colors.red[900]!,
                ),
              ),
          ],
        ),

        // Show loading or error states if necessary
        if (provider.error != null)
          Text(
            provider.error!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildWordChip({
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
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
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
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
    return CustomSection(
      title: title,
      backgroundColor: cardColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.map((word) {
              return _buildWordChip(
                text: word,
                backgroundColor: chipColor,
                textColor: textColor,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              // Toggle the input visibility (handled by the provider)

              context.read<WordProvider>().setLoading(true);
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
