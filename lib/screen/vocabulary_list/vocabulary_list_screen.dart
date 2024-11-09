// models/vocabulary_word.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../models/word.dart';
import '../../models/word_card_config.dart';
import '../../providers/vocabulary_provider.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final Function(String) onFavoriteToggle;
  final Function(String)? onDelete;
  final Function(String)? onShare;
  final Function(String)? onEdit;
  final WordCardConfig config;
  final double? maxWidth;

  const WordCard({
    super.key,
    required this.word,
    required this.onFavoriteToggle,
    this.onDelete,
    this.onShare,
    this.onEdit,
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
          if (config.showTags && word.tags.isNotEmpty) ...[
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
          motion: const ScrollMotion(),
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
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                Navigator.pushNamed(context, '/word-details', arguments: word),
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
      word.definition,
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
      children: word.tags.map((tag) => _buildTag(tag)).toList(),
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

class VocabularyListScreen extends StatelessWidget {
  const VocabularyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Vocabulary'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Show sorting options
              _showSortingOptions(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildCategoryFilter(context),
          Expanded(
            child: Consumer<VocabularyProvider>(
              builder: (context, provider, child) {
                final words = provider.filteredWords;

                if (words.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No words found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return WordCard(
                      word: words[index],
                      config: WordCardConfig(
                        showDefinition: true,
                        showTranslation: true,
                        showMasteryScore: true,
                        showTags: true,
                        enableSlideActions: true,
                      ),
                      maxWidth: 600,
                      onFavoriteToggle: (String) {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add word screen
          Navigator.pushNamed(context, '/add-word');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          context.read<VocabularyProvider>().setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search words...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = [
      'All',
      'Business',
      'Academic',
      'Daily Life',
      'Technology'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: context.watch<VocabularyProvider>().selectedCategory ==
                  category,
              onSelected: (selected) {
                if (selected) {
                  context.read<VocabularyProvider>().setCategory(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showSortingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Recently Added'),
                onTap: () {
                  // Implement sorting
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.sort_by_alpha),
                title: Text('Alphabetical'),
                onTap: () {
                  // Implement sorting
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Mastery Level'),
                onTap: () {
                  // Implement sorting
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Favorites Only'),
                onTap: () {
                  // Implement filtering
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('Needs Review'),
                onTap: () {
                  // Implement filtering
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Mastered'),
                onTap: () {
                  // Implement filtering
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
