import 'package:flutter/material.dart';
import 'package:my_lab/screen/word_detail/custom_section.dart';

class WordRelationsWidget extends StatelessWidget {
  final List<String> synonyms;
  final List<String> antonyms;

  const WordRelationsWidget({
    super.key,
    required this.synonyms,
    required this.antonyms,
  });

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

  Widget _buildWordList({
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
      child: Wrap(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (synonyms.isEmpty && antonyms.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        if (synonyms.isNotEmpty) ...[
          Expanded(
            child: _buildWordList(
              title: "Synonyms",
              words: synonyms,
              cardColor: Colors.green[50]!,
              chipColor: Colors.green[100]!,
              textColor: Colors.green[900]!,
            ),
          ),
          if (antonyms.isNotEmpty) const SizedBox(width: 16),
        ],
        if (antonyms.isNotEmpty)
          Expanded(
            child: _buildWordList(
              title: "Antonyms",
              words: antonyms,
              cardColor: Colors.red[50]!,
              chipColor: Colors.red[100]!,
              textColor: Colors.red[900]!,
            ),
          ),
      ],
    );
  }
}
