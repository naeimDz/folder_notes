import 'package:flutter/material.dart';
import 'package:my_lab/models/word.dart';
import 'package:my_lab/screen/home/word_of_the_day_widget.dart';
import 'package:my_lab/screen/shared/widgets/custom_sliver_app_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/form_state_provider.dart';
import '../../providers/metadata_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/word_provider.dart';
import '../advanced_features/analytics_screen.dart';
import '../advanced_features/categories_screen.dart';
import '../advanced_features/space_practice.dart';
import '../advanced_features/test.dart';
import '../vocabulary_list/vocabulary_list_screen.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final int progress = 65;
  final int dailyGoal = 80;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  // PageController for managing PageView
  late PageController _pageController;
  // ignore: unused_field
  int _currentIndex = 0;

  final List<Map<String, dynamic>> recentActivity = [
    {
      "action": "Completed Daily Quiz",
      "time": "1h ago",
      "icon": Icons.assignment_turned_in,
      "color": Colors.green
    },
    {
      "action": "Added 3 new words",
      "time": "3h ago",
      "icon": Icons.add_circle,
      "color": Colors.blue
    },
    {
      "action": "Achieved 7-day streak!",
      "time": "1d ago",
      "icon": Icons.local_fire_department,
      "color": Colors.orange
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: progress / dailyGoal,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getThemeMode() == ThemeMode.dark;
    print("build home screen");
    return Scaffold(
      // floatingActionButton: _buildFloatingActionButton(context),
      body: PageView(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe if needed
          children: [
            CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title: widget.title,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SliverExampleApp()),
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeHeader(),
                        SizedBox(height: 24),
                        _buildAnimatedProgress(context),
                        SizedBox(height: 24),
                        _buildEnhancedStats(context),
                        SizedBox(height: 24),
                        WordOfTheDayWidget(),
                        SizedBox(height: 24),
                        _buildTodaysWords(isDark),
                        SizedBox(height: 24),
                        _buildRecentActivityTimeline(isDark),
                        SizedBox(height: 24),
                        _buildQuickActionCards(context, isDark),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VocabularyListScreen(),
            //  AddWordScreen(),
            Center(child: Text('Profile Page')),
          ]),
      bottomNavigationBar: _buildGlassBottomNav(isDark, (index) {
        setState(() {
          _currentIndex = index;
        });
        _pageController.jumpToPage(index);
      }),
    );
  }

  Widget _buildWelcomeHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
      child: Text(
        "Ready to expand your vocabulary?",
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildAnimatedProgress(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daily Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$progress%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    FractionallySizedBox(
                      widthFactor: _progressAnimation.value,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 15),
          Text(
            "Keep going! You're almost there!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStats(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Selector<MetadataProvider, int?>(
              selector: (_, provider) => provider.wordCount,
              builder: (context, wordCount, child) {
                return _buildStatCard(
                  '/word-list',
                  "Words Mastered",
                  wordCount.toString(),
                  Icons.auto_awesome,
                  [Colors.purple[400]!, Colors.purple[600]!],
                  context,
                );
              }),
          _buildStatCard(
            "/progress",
            "Current Streak",
            "7 days",
            Icons.local_fire_department,
            [Colors.orange[400]!, Colors.orange[600]!],
            context,
          ),
          _buildStatCard(
            "/analyse",
            "Time Studied",
            "2.5 hrs",
            Icons.timer,
            [Colors.green[400]!, Colors.green[600]!],
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String nextScreen, String title, String value,
      IconData icon, List<Color> gradientColors, BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, nextScreen),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysWords(bool isDark) {
    return Selector<WordProvider, List<Word>>(
      selector: (_, provider) => provider.todaysWords,
      builder: (context, todaysWords, child) {
        // If there are no words for today, show an empty message
        if (todaysWords.isEmpty) {
          return Center(
            child: Text(
              "No words available for today",
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          );
        }

        // Display today's words if available
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Today's Words",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            ...todaysWords.map((word) => _buildWordCard(word, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildWordCard(Word word, bool isDark) {
    Color difficultyColor;
    switch (word.difficulty.name) {
      case 'beginner':
        difficultyColor = Colors.green;
        break;
      case 'intermediate':
        difficultyColor = Colors.orange;
        break;
      case 'advanced':
        difficultyColor = Colors.purple;
        break;
      case 'expert':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.red;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Set the selected word in the provider
            context.read<FormStateProvider>().selectWord(word);
            Navigator.pushNamed(context, "/word-details");
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      word.word[0],
                      style: TextStyle(
                        color: difficultyColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        word.translation,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        word.difficulty.name,
                        style: TextStyle(
                          color: difficultyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      word.dateAdded.day.toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityTimeline(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Activity",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...recentActivity.asMap().entries.map((entry) {
          final activity = entry.value;
          final isLast = entry.key == recentActivity.length - 1;

          return IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: activity['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        activity['icon'],
                        color: activity['color'],
                        size: 20,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Colors.grey[300],
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['action'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          activity['time'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickActionCards(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildQuickActionCard(
              "Practice",
              "Start daily quiz",
              Icons.psychology,
              [Colors.purple[400]!, Colors.purple[600]!],
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpacedRepetitionPractice()),
              ),
            ),
            _buildQuickActionCard(
              "Flashcards",
              "Review saved words",
              Icons.style,
              [Colors.orange[400]!, Colors.orange[600]!],
              () {},
            ),
            _buildQuickActionCard(
              "Analytics",
              "Track progress",
              Icons.insert_chart,
              [Colors.blue[400]!, Colors.blue[600]!],
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnalyticsScreen()),
              ),
            ),
            _buildQuickActionCard(
              "Categories",
              "Browse words",
              Icons.category,
              [Colors.green[400]!, Colors.green[600]!],
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon,
      List<Color> gradientColors, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBottomNav(bool isDark, void Function(int)? onTap) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]!.withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue[600],
            unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.book), label: 'Dictionary'),
              //   BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Word'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
