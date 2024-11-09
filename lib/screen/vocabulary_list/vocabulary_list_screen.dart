// models/vocabulary_word.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/word_card_config.dart';
import '../../providers/vocabulary_provider.dart';
import 'word_card.dart';

class VocabularyListScreen extends StatelessWidget {
  const VocabularyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern Header Section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back)),
                    // Top Row with Title and Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Vocabulary',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Consumer<VocabularyProvider>(
                              builder: (context, provider, _) => Text(
                                '${provider.filteredWords.length} words',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildHeaderButton(
                              context,
                              icon: Icons.workspace_premium,
                              label: 'Progress',
                              onTap: () {
                                // Navigate to progress/stats screen
                                Navigator.pushNamed(context, '/progress');
                              },
                            ),
                            SizedBox(width: 12),
                            _buildHeaderButton(
                              context,
                              icon: Icons.more_horiz,
                              label: 'More',
                              onTap: () => _showMoreOptions(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Modern Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
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
                              .read<VocabularyProvider>()
                              .setSearchQuery(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search your vocabulary...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Filter Pills
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterPill(
                            context,
                            icon: Icons.sort,
                            label: 'Sort',
                            onTap: () => _showSortingOptions(context),
                          ),
                          SizedBox(width: 8),
                          _buildFilterPill(
                            context,
                            icon: Icons.filter_list,
                            label: 'Filter',
                            onTap: () => _showFilterOptions(context),
                          ),
                          SizedBox(width: 8),
                          ..._buildCategoryPills(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Words List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              sliver: Consumer<VocabularyProvider>(
                builder: (context, provider, child) {
                  final words = provider.filteredWords;

                  if (words.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No words found',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: WordCard(
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
                          ),
                        );
                      },
                      childCount: words.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-word'),
        icon: Icon(Icons.add),
        label: Text('Add Word'),
        elevation: 4,
      ),
    );
  }

  Widget _buildHeaderButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            children: [
              Icon(icon, size: 24),
              SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryPills(BuildContext context) {
    final categories = [
      'All',
      'Business',
      'Academic',
      'Daily Life',
      'Technology'
    ];
    final theme = Theme.of(context);

    return categories.map((category) {
      final isSelected =
          context.watch<VocabularyProvider>().selectedCategory == category;

      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              context.read<VocabularyProvider>().setCategory(category);
            }
          },
          selectedColor: theme.colorScheme.primary.withOpacity(0.2),
          checkmarkColor: theme.colorScheme.primary,
          labelStyle: TextStyle(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      );
    }).toList();
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'More Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            _buildMoreOption(
              context,
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Customize your learning experience',
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            _buildMoreOption(
              context,
              icon: Icons.backup,
              title: 'Backup & Sync',
              subtitle: 'Manage your vocabulary data',
              onTap: () => Navigator.pushNamed(context, '/backup'),
            ),
            _buildMoreOption(
              context,
              icon: Icons.help_outline,
              title: 'Help & Feedback',
              subtitle: 'Get support or share your thoughts',
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
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
