import 'package:flutter/material.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Sections visibility state
  final Map<String, bool> _expandedSections = {
    'wordDetails': true,
    'definition': false,
    'examples': false,
    'synonymsAntonyms': false,
    'tags': false,
  };

  // Progress tracking
  double get _completionProgress {
    int filledSections = _expandedSections.values.where((v) => v).length;
    return filledSections / _expandedSections.length;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Modern Header
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            // Main Content
            SliverPadding(
              padding: EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Progress Indicator
                      _buildProgressIndicator(context),
                      SizedBox(height: 24),

                      // Word Details Section
                      _buildModernSection(
                        context: context,
                        title: 'Word Details',
                        sectionKey: 'wordDetails',
                        leadingIcon: Icons.text_fields,
                        child: _buildWordDetailsContent(context),
                      ),

                      // Definition Section
                      _buildModernSection(
                        context: context,
                        title: 'Definition & Usage',
                        sectionKey: 'definition',
                        leadingIcon: Icons.description,
                        child: _buildDefinitionContent(context),
                      ),

                      // Examples Section
                      _buildModernSection(
                        context: context,
                        title: 'Examples',
                        sectionKey: 'examples',
                        leadingIcon: Icons.format_quote,
                        child: _buildExamplesContent(context),
                      ),

                      // Synonyms & Antonyms
                      _buildModernSection(
                        context: context,
                        title: 'Related Words',
                        sectionKey: 'synonymsAntonyms',
                        leadingIcon: Icons.compare_arrows,
                        child: _buildRelatedWordsContent(context),
                      ),

                      // Tags Section
                      _buildModernSection(
                        context: context,
                        title: 'Categories & Tags',
                        sectionKey: 'tags',
                        leadingIcon: Icons.local_offer,
                        child: _buildTagsContent(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.arrow_back, size: 24),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Word',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fill in the details below',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildQuickActionButton(
                context: context,
                icon: Icons.camera_alt,
                label: 'Scan',
                onTap: () {
                  // Implement OCR scanning
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Completion Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${(_completionProgress * 100).round()}%',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _completionProgress,
            minHeight: 8,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSection({
    required BuildContext context,
    required String title,
    required String sectionKey,
    required IconData leadingIcon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isExpanded = _expandedSections[sectionKey] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[sectionKey] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      leadingIcon,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(height: 0),
            secondChild: Padding(
              padding: EdgeInsets.all(16),
              child: child,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  Widget _buildWordDetailsContent(BuildContext context) {
    return Column(
      children: [
        _buildModernTextField(
          label: 'Word',
          hint: 'Enter the word',
          suffix: IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () {
              // Implement text-to-speech
            },
          ),
        ),
        SizedBox(height: 16),
        _buildModernTextField(
          label: 'Translation',
          hint: 'Enter translation',
          suffix: IconButton(
            icon: Icon(Icons.translate),
            onPressed: () {
              // Implement auto-translation
            },
          ),
        ),
        SizedBox(height: 16),
        _buildModernTextField(
          label: 'Phonetic',
          hint: 'Enter phonetic transcription',
          suffix: IconButton(
            icon: Icon(Icons.record_voice_over),
            onPressed: () {
              // Implement voice recording
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDefinitionContent(BuildContext context) {
    return Column(
      children: [
        _buildModernTextField(
          label: 'Brief Definition',
          hint: 'Enter a concise definition',
          maxLines: 2,
        ),
        SizedBox(height: 16),
        _buildModernTextField(
          label: 'Extended Definition',
          hint: 'Provide a detailed explanation with context',
          maxLines: 3,
        ),
        SizedBox(height: 16),
        _buildPartOfSpeechSelector(),
      ],
    );
  }

  Widget _buildPartOfSpeechSelector() {
    final parts = ['Noun', 'Verb', 'Adjective', 'Adverb', 'Other'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Part of Speech',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: parts.map((part) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(part),
                  selected: false,
                  onSelected: (selected) {
                    // Implement selection
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExamplesContent(BuildContext context) {
    return Column(
      children: [
        _buildModernTextField(
          label: 'Example 1',
          hint: 'Enter an example sentence in English',
          maxLines: 2,
        ),
        SizedBox(height: 16),
        _buildModernTextField(
          label: 'Translation',
          hint: 'Enter the translation',
          maxLines: 2,
        ),
        SizedBox(height: 16),
        _buildAddExampleButton(),
      ],
    );
  }

  Widget _buildAddExampleButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // Add new example fields
      },
      icon: Icon(Icons.add),
      label: Text('Add Another Example'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildRelatedWordsContent(BuildContext context) {
    return Column(
      children: [
        _buildModernTextField(
          label: 'Synonyms',
          hint: 'Enter synonyms separated by commas',
        ),
        SizedBox(height: 16),
        _buildModernTextField(
          label: 'Antonyms',
          hint: 'Enter antonyms separated by commas',
        ),
      ],
    );
  }

  Widget _buildTagsContent(BuildContext context) {
    return Column(
      children: [
        _buildCategorySelector(),
        SizedBox(height: 16),
        _buildModernTextField(
          label: 'Custom Tags',
          hint: 'Add custom tags separated by commas',
          suffix: Icon(Icons.tag),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      'Business',
      'Academic',
      'Daily Life',
      'Technology',
      'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return FilterChip(
              label: Text(category),
              selected: false,
              onSelected: (selected) {
                // Implement category selection
              },
              avatar: Icon(
                _getCategoryIcon(category),
                size: 16,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Business':
        return Icons.business_center;
      case 'Academic':
        return Icons.school;
      case 'Daily Life':
        return Icons.home;
      case 'Technology':
        return Icons.computer;
      default:
        return Icons.category;
    }
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showDiscardDialog(context),
                icon: Icon(Icons.close),
                label: Text('Discard'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _saveWord,
                icon: Icon(Icons.check),
                label: Text('Save Word'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Changes?'),
        content: Text(
            'Are you sure you want to discard your changes? This action cannot be undone.'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close add word screen
            },
            child: Text(
              'Discard',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _saveWord() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Saving word...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate saving
      await Future.delayed(Duration(seconds: 2));

      // Show success and pop
      Navigator.pop(context); // Remove loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Word saved successfully!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  // Helper method to show tooltips
  void _showTooltip(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inverseSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
