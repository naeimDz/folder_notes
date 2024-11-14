import 'package:flutter/material.dart';
import 'package:my_lab/screen/word_detail/custom_section.dart';
import '../../models/word.dart';
import 'word_input.dart';

class WordRelationsWidget extends StatefulWidget {
  final Word word;

  const WordRelationsWidget({
    super.key,
    required this.word,
  });

  @override
  State<WordRelationsWidget> createState() => _WordRelationsWidgetState();
}

class _WordRelationsWidgetState extends State<WordRelationsWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isAddingNewWord =
      false; // Flag to control the add word section visibility
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              setState(() {
                _isAddingNewWord = !_isAddingNewWord; // Toggle add word section
              });
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

  @override
  Widget build(BuildContext context) {
    final synonyms = widget.word.details?.synonyms ?? [];
    final antonyms = widget.word.details?.antonyms ?? [];

    if (synonyms.isEmpty && antonyms.isEmpty) {
      return Center(
        child: TextButton.icon(
          onPressed: () {
            setState(() {
              _isAddingNewWord = !_isAddingNewWord; // Toggle add word section
            });
          },
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Add your first word'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Show the input section for adding a new word

        WordInput(
          isVisible: _isAddingNewWord,
          onSave: (word, type) {
            // Handle saving

            setState(() {
              if (type == 'Synonym') {
                synonyms.add(word);
              } else {
                antonyms.add(word);
              }
            });
          },
          onHide: () {
            // Handle hide
            setState(() => _isAddingNewWord = false);
          },
        ),

        Row(
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
        ),
      ],
    );
  }
}
