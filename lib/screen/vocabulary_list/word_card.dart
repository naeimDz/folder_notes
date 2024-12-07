import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_lab/models/word_card_config.dart';
import 'package:provider/provider.dart';

import '../../models/word.dart';
import '../../providers/form_state_provider.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final Function(String) onFavoriteToggle;
  final Function(String)? onDelete;
  final Function(String)? onShare;
  final Function(String)? onEdit;
  final Function(String)? onArchive;
  final Function(String)? onMarkAsLearned;
  final WordCardConfig config;
  final double? maxWidth;

  const WordCard({
    super.key,
    required this.word,
    required this.onFavoriteToggle,
    this.onDelete,
    this.onShare,
    this.onEdit,
    this.onArchive,
    this.onMarkAsLearned,
    this.config = const WordCardConfig(),
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    Widget cardContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isSmallScreen),
          if (config.showDefinition) ...[
            const SizedBox(height: 12),
            _buildDefinition(theme),
          ],
          if (config.showMasteryScore) ...[
            const SizedBox(height: 12),
            _buildMasteryIndicator(),
          ],
          if (config.showTags && word.details!.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildTags(),
          ],
        ],
      ),
    );

    if (config.enableSlideActions) {
      cardContent = Slidable(
        key: ValueKey(word.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            if (onEdit != null)
              SlidableAction(
                onPressed: (_) => onEdit!(word.id as String),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            if (onShare != null)
              SlidableAction(
                onPressed: (_) => onShare!(word.id as String),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.share,
                label: 'Share',
              ),
            if (onArchive != null)
              SlidableAction(
                onPressed: (_) => onArchive!(word.id as String),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                icon: Icons.archive,
                label: 'Archive',
              ),
            if (onMarkAsLearned != null)
              SlidableAction(
                onPressed: (_) => onMarkAsLearned!(word.id as String),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                icon: Icons.check_circle,
                label: 'Learned',
              ),
            if (onDelete != null)
              SlidableAction(
                onPressed: (_) => onDelete!(word.id as String),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
          ],
        ),
        child: cardContent,
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Set the selected word in the provider
              context.read<FormStateProvider>().selectWord(word);
              Navigator.pushNamed(
                context,
                '/word-details',
              );
            },
            child: Hero(
              tag: 'word-${word.id}',
              child: cardContent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (config.showTranslation) ...[
                      const SizedBox(height: 4),
                      Text(
                        word.translation,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                    ],
                  ],
                )
              : Row(
                  children: [
                    Text(
                      word.word,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (config.showTranslation) ...[
                      const SizedBox(width: 16),
                      Text(
                        word.translation,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                    ],
                  ],
                ),
        ),
        _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onFavoriteToggle(word.id as String),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: word.isFavorite
                ? Colors.amber.withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Icon(
            word.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: word.isFavorite ? Colors.amber : Colors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildDefinition(ThemeData theme) {
    return Text(
      word.details?.definition ?? "",
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildMasteryIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mastery: ${word.masteryScore.toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: word.masteryScore / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              HSLColor.fromAHSL(
                1.0,
                120 * (word.masteryScore / 100),
                0.8,
                0.4,
              ).toColor(),
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: word.details?.tags.map((tag) => _buildTag(tag)).toList() ?? [],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}
