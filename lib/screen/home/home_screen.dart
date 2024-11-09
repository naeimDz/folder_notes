import 'package:flutter/material.dart';
import 'package:folder_notes/providers/theme_provider.dart';
import 'package:folder_notes/screen/advanced_features/analytics_screen.dart';
import 'package:folder_notes/screen/advanced_features/space_practice.dart';
import 'package:folder_notes/screen/word_detail/word_detail.dart';
import 'package:provider/provider.dart';

import '../vocabulary_list/vocabulary_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  HomeScreen({super.key, required this.title});

  final int progress = 65;
  final int dailyGoal = 80; // Daily goal for progress visualization
  final List<Map<String, String>> todaysWords = [
    {"word": "Resilient", "translation": "مرن", "timeAdded": "2h ago"},
    {"word": "Ambitious", "translation": "طموح", "timeAdded": "3h ago"},
    {"word": "Genuine", "translation": "حقيقي", "timeAdded": "5h ago"}
  ];

  final List<Map<String, String>> recentActivity = [
    {"action": "Completed Daily Quiz", "time": "1h ago"},
    {"action": "Added 3 new words", "time": "3h ago"},
    {"action": "Achieved 7-day streak!", "time": "1d ago"}
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      bottomNavigationBar: _buildBottomNav(),
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VocabularyListScreen(),
                  )),
              icon: Icon(Icons.add)),
          Switch(
            value: themeProvider.getThemeMode() == ThemeMode.dark,
            onChanged: (value) {
              themeProvider
                  .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ready to expand your English vocabulary?",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 8),

              // 1. Enhanced Daily Goal Progress Visualization
              _buildDailyGoalProgress(context),
              SizedBox(height: 8),
              // Stats Overview
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard("Words Learned", "248", Icons.book, context),
                    _buildStatCard("Current Streak", "7 days",
                        Icons.emoji_events, context),
                    _buildStatCard(
                        "Mastery Level", "Advanced", Icons.psychology, context),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Main Content
              _buildProgressCard(),
              _buildWordsCard(),
              SizedBox(height: 16),

              // 2. Enhanced Word of the Day Section
              _buildEnhancedWordOfTheDay(context),
              SizedBox(height: 16),

              // 3. Interactive Daily Quiz Widget
              _buildDailyQuizWidget(context),
              // Quick Actions

              _buildAlertCard(Icons.book, "Review Flashcards",
                  "Practice with your saved words", context),
              _buildAlertCard(Icons.emoji_events, "View Progress",
                  "Check your learning statistics", context),
            ],
          ),
        ),
      ),
    );
  }

  // New: Daily Goal Progress Widget
  Widget _buildDailyGoalProgress(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalyticsScreen(),
          )),
      child: Card(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Goal Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                  value: progress / dailyGoal,
                  backgroundColor: Colors.grey[300]),
              SizedBox(height: 10),
              Text(
                "$progress% of your daily goal achieved!",
                style: TextStyle(fontSize: 16, color: Colors.blue[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Existing: Progress Card
  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Progress", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            LinearProgressIndicator(value: progress / 100),
            SizedBox(height: 16),
            Column(
              children: recentActivity.map((activity) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(activity["action"]!, style: TextStyle(fontSize: 14)),
                      Text(activity["time"]!,
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Existing: Words Card
  Widget _buildWordsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Words", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Column(
              children: todaysWords.map((word) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(word["word"]!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(word["translation"]!,
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(word["timeAdded"]!,
                              style: TextStyle(color: Colors.grey)),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.bookmark_border),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Word of the Day Section
  Widget _buildEnhancedWordOfTheDay(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordDetailScreen(),
          )),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Word of the Day",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Resilient",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Pronunciation: /rɪˈzɪlɪənt/",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Text(
                "Meaning: Able to recover quickly from difficult conditions.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Example: She showed a resilient attitude despite the setbacks.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Related Words: Durable, Strong",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                "Synonyms: Tough, Flexible",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Interactive Daily Quiz Widget
  Widget _buildDailyQuizWidget(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpacedRepetitionPractice(),
          )),
      child: Card(
        color: Colors.yellow[50],
        child: ListTile(
          leading: Icon(Icons.psychology, color: Colors.blue),
          title: Text("Start Daily Quiz"),
          subtitle: Text("Test your knowledge of today's words"),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpacedRepetitionPractice(),
                  ));
            },
            child: Text("Start"),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(
      IconData icon, String title, String description, BuildContext context) {
    return InkWell(
      child: Card(
        color: Colors.grey[200],
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          subtitle: Text(description),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VocabularyListScreen(),
          )),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey[500])),
                  Text(value,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Icon(icon, color: Colors.blue, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Dictionary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.psychology),
          label: 'Practice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
