import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/word_card_config.dart';
import '../../providers/vocabulary_provider.dart';
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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(context),
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
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Vocabulary',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[200]!.withOpacity(0.7),
                Colors.white,
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
        onPressed: () => Navigator.pop(context),
      ),
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
                context.read<VocabularyProvider>().setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search words...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
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
                    isSelected: true),
                _buildAnimatedFilterChip(
                    label: 'Favorites',
                    icon: Icons.favorite,
                    isSelected: false),
                _buildAnimatedFilterChip(
                    label: 'Recent',
                    icon: Icons.access_time,
                    isSelected: false),
                _buildAnimatedFilterChip(
                    label: 'Mastered', icon: Icons.verified, isSelected: false),
                _buildAnimatedFilterChip(
                    label: 'Alphabetical',
                    icon: Icons.sort_by_alpha,
                    isSelected: false),
                _buildAnimatedFilterChip(
                    label: 'Mastery Level',
                    icon: Icons.bar_chart,
                    isSelected: false),
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
    required bool isSelected,
  }) {
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
        onSelected: (bool selected) {
          // Handle filter selection
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
  }

  Widget _buildVocabularyStats(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context: context,
            value: '248',
            label: 'Total Words',
            icon: Icons.book,
            color: Colors.blue,
          ),
          _buildStatItem(
            context: context,
            value: '85%',
            label: 'Mastery',
            icon: Icons.school,
            color: Colors.green,
          ),
          _buildStatItem(
            context: context,
            value: '12',
            label: 'To Review',
            icon: Icons.refresh,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordsList(BuildContext context) {
    return Consumer<VocabularyProvider>(
      builder: (context, provider, child) {
        final words = provider.filteredWords;

        if (words.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.all(8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (index / words.length).clamp(0.0, 1.0),
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
                        onMarkAsLearned: (p0) => print("we are here test"),
                        word: words[index],
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
                        onShare: (wordId) {
                          print("Share word with id: $wordId");
                        },
                        onDelete: (wordId) {
                          print("deletz!!!");
                        },
                        onFavoriteToggle: (String) {
                          print("favorite one");
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: words.length,
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

  Widget _buildFloatingActionButton(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          _animationController
              .forward()
              .then((_) => _animationController.reverse());
          Navigator.pushNamed(context, '/add-word');
        },
        icon: Icon(Icons.add),
        label: Text('Add Word'),
        elevation: 4,
        backgroundColor: Colors.blue[600],
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
