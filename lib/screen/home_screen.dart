import 'package:flutter/material.dart';
import 'package:folder_notes/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  HomeScreen({super.key, required this.title});

  final int progress = 65;
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
      appBar: AppBar(
        title: Text(title),
        actions: [
          Switch(
            value: themeProvider.getThemeMode() == ThemeMode.dark,
            onChanged: (value) {
              // Toggle theme on switch change
              themeProvider
                  .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap entire body in SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ready to expand your English vocabulary?",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              // Word of the Day Section

              // Stats Overview (Horizontal Scrollable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard("Words Learned", "248", Icons.book),
                    _buildStatCard(
                        "Current Streak", "7 days", Icons.emoji_events),
                    _buildStatCard(
                        "Mastery Level", "Advanced", Icons.psychology),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Main Content
              _buildProgressCard(),
              _buildWordsCard(),
              SizedBox(height: 16),
              _buildWordOfTheDay(),
              SizedBox(height: 16),
              // Quick Actions
              _buildAlertCard(Icons.psychology, "Start Daily Quiz",
                  "Test your knowledge of recent words"),
              _buildAlertCard(Icons.book, "Review Flashcards",
                  "Practice with your saved words"),
              _buildAlertCard(Icons.emoji_events, "View Progress",
                  "Check your learning statistics"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
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
    );
  }

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

  Widget _buildAlertCard(IconData icon, String title, String description) {
    return Card(
      color: Colors.grey[200],
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildWordOfTheDay() {
    return Card(
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
          ],
        ),
      ),
    );
  }
}
