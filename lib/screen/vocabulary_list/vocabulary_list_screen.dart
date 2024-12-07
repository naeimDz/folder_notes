import 'package:flutter/material.dart';
import 'package:my_lab/screen/shared/widgets/custom_sliver_app_bar.dart';
import 'package:provider/provider.dart';
import '../../models/word_card_config.dart';
import '../../providers/filter_provider.dart';
import '../../providers/word_provider.dart';

import 'word_card.dart';

class VocabularyListScreen extends StatefulWidget {
  const VocabularyListScreen({super.key});

  @override
  State<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends State<VocabularyListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showElevation = _scrollController.offset > 0;
        });
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("scaffold _VocabularyListScreenStat");
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              CustomSliverAppBar(
                title: "My Vocabulary",
                actions: [
                  IconButton(
                    icon: Icon(Icons.analytics_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/progress'),
                    color: Theme.of(context).iconTheme.color,
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () => _showMoreOptions(context),
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildSearchAndFilters(context),
                  ],
                ),
              ),
              _buildWordsList(context),
            ],
          ),
          if (_showElevation)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Enhanced Search Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                context
                    .read<WordProvider>()
                    .setSearchQuery(value); // Update query
              },
              decoration: InputDecoration(
                hintText: 'Search words...',
                prefixIcon: Icon(Icons.search),
                // suffixIcon: Icon(Icons.mic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          SizedBox(height: 16),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAnimatedFilterChip(
                  label: 'All Words',
                  icon: Icons.format_list_bulleted,
                ),
                _buildAnimatedFilterChip(
                  label: 'Favorites',
                  icon: Icons.favorite,
                ),
                _buildAnimatedFilterChip(
                  label: 'Recent',
                  icon: Icons.access_time,
                ),
                _buildAnimatedFilterChip(
                  label: 'Mastered',
                  icon: Icons.verified,
                ),
                _buildAnimatedFilterChip(
                  label: 'Alphabetical',
                  icon: Icons.sort_by_alpha,
                ),
                _buildAnimatedFilterChip(
                  label: 'Mastery Level',
                  icon: Icons.bar_chart,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFilterChip({
    required String label,
    required IconData icon,
  }) {
    print("builid animated filter");
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        final isSelected = filterProvider.filters[label] ?? false;
        return Padding(
          padding: EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
                SizedBox(width: 4),
                Text(label),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              context.read<FilterProvider>().toggleFilter(label);
            },
            backgroundColor: Colors.grey[200],
            selectedColor: Colors.blue[600],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[800],
            ),
            elevation: 0,
            pressElevation: 2,
          ),
        );
      },
    );
  }

  Widget _buildWordsList(BuildContext context) {
    print('buildlist');
    return Consumer2<WordProvider, FilterProvider>(
      builder: (context, wordProvider, filterProvider, child) {
        final selectedFilter = filterProvider.filters.entries
            .firstWhere((entry) => entry.value)
            .key; // Get the selected filter
        final filteredWords = wordProvider.getFilteredWords(selectedFilter);
        if (filteredWords.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: _buildEmptyState()),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.all(8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final word = filteredWords[index];
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (index / filteredWords.length).clamp(0.0, 1.0),
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: WordCard(
                        word: word,
                        config: WordCardConfig(
                          showDefinition: true,
                          showTranslation: true,
                          showMasteryScore: true,
                          showTags: true,
                          enableSlideActions: true,
                        ),
                        maxWidth: 600,
                        onEdit: (wordId) {
                          print("Edit word with id: $wordId");
                        },
                        onMarkAsLearned: (word) =>
                            print("Mark as learned: $word"),
                        onDelete: (wordId) {
                          wordProvider.deleteWord(wordId);
                        },
                        onFavoriteToggle: (wordId) {
                          wordProvider.toggleFavorite(wordId);
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredWords.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No words found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.sort),
              title: Text('Sort'),
            ),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text('Backup & Sync'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
