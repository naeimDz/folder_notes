import 'package:flutter/material.dart';
import 'package:my_lab/screen/word_detail/custom_section.dart';
import 'package:provider/provider.dart';

import '../../models/word.dart';
import '../../models/word_details.dart';
import '../../providers/word_provider.dart';

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
  bool _isAddingSynonym = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAddWord(String newWord, bool isSynonym) async {
    final wordProvider = context.read<WordProvider>();

    // Create a copy of the current word with updated relations
    Word updatedWord = widget.word;

    if (widget.word.details != null) {
      List<String> updatedSynonyms = List.from(widget.word.details!.synonyms);
      List<String> updatedAntonyms = List.from(widget.word.details!.antonyms);

      if (isSynonym) {
        if (!updatedSynonyms.contains(newWord)) {
          updatedSynonyms.add(newWord);
        }
      } else {
        if (!updatedAntonyms.contains(newWord)) {
          updatedAntonyms.add(newWord);
        }
      }

      // Create new WordDetails with updated synonyms/antonyms
      WordDetails updatedDetails = WordDetails(
        definitions: widget.word.details!.definitions,
        synonyms: updatedSynonyms,
        antonyms: updatedAntonyms,
        pronunciation: widget.word.details!.pronunciation,
        partOfSpeech: widget.word.details!.partOfSpeech,
        usageNotes: widget.word.details!.usageNotes,
        collocations: widget.word.details!.collocations,
        audioUrl: widget.word.details!.audioUrl,
        imageUrl: widget.word.details!.imageUrl,
        customProperties: widget.word.details!.customProperties,
      );

      // Create updated Word with new details
      updatedWord = Word(
        id: widget.word.id,
        word: widget.word.word,
        translation: widget.word.translation,
        definition: widget.word.definition,
        dateAdded: widget.word.dateAdded,
        lastReviewed: widget.word.lastReviewed,
        isFavorite: widget.word.isFavorite,
        examples: widget.word.examples,
        difficulty: widget.word.difficulty,
        tags: widget.word.tags,
        masteryScore: widget.word.masteryScore,
        reviewStatus: widget.word.reviewStatus,
        details: updatedDetails,
        customProperties: widget.word.customProperties,
      );

      // Update the word using the provider
      await wordProvider.updateWord(updatedWord);
    }
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

  void _showAddWordDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Word',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter word',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton(
                        text: 'Synonym',
                        isSelected: _isAddingSynonym,
                        color: Colors.green,
                        onTap: () => setState(() => _isAddingSynonym = true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildToggleButton(
                        text: 'Antonym',
                        isSelected: !_isAddingSynonym,
                        color: Colors.red,
                        onTap: () => setState(() => _isAddingSynonym = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<WordProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (_controller.text.isNotEmpty) {
                                await _handleAddWord(
                                  _controller.text,
                                  _isAddingSynonym,
                                );
                                _controller.clear();
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAddingSynonym
                            ? Colors.green[600]
                            : Colors.red[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Add Word',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
                if (context
                    .select((WordProvider p) => p.error?.isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      context.select((WordProvider p) => p.error ?? ''),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
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
            onPressed: _showAddWordDialog,
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
          onPressed: _showAddWordDialog,
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
