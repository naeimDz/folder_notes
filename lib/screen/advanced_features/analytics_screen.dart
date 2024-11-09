import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _timeFrames = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  String _selectedTimeFrame = 'Weekly';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Progress'),
            Tab(text: 'Achievements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildProgressTab(),
          _buildAchievementsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeFrameSelector(),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildLearningStreak(),
          const SizedBox(height: 24),
          _buildWordCategoriesChart(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _timeFrames.length,
        itemBuilder: (context, index) {
          final timeFrame = _timeFrames[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(timeFrame),
              selected: _selectedTimeFrame == timeFrame,
              onSelected: (selected) {
                setState(() => _selectedTimeFrame = timeFrame);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          title: 'Words Learned',
          value: '248',
          trend: '+12 this week',
          icon: Icons.library_books,
          trendPositive: true,
        ),
        _buildMetricCard(
          title: 'Current Streak',
          value: '7 days',
          trend: 'Best: 15 days',
          icon: Icons.local_fire_department,
          trendPositive: true,
        ),
        _buildMetricCard(
          title: 'Quiz Accuracy',
          value: '85%',
          trend: '+5% vs last week',
          icon: Icons.quiz,
          trendPositive: true,
        ),
        _buildMetricCard(
          title: 'Study Time',
          value: '12.5 hrs',
          trend: '2.5 hrs today',
          icon: Icons.timer,
          trendPositive: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required bool trendPositive,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              children: [
                Icon(
                  trendPositive ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: trendPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningStreak() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Streak',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final bool isToday = index == 6;
                  final bool completed = index < 6;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildDayStreak(
                      day: DateFormat('E').format(
                        DateTime.now().subtract(Duration(days: 6 - index)),
                      ),
                      completed: completed,
                      isToday: isToday,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayStreak({
    required String day,
    required bool completed,
    required bool isToday,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? Colors.green
                : isToday
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
          ),
          child: Icon(
            completed ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(day),
      ],
    );
  }

  Widget _buildWordCategoriesChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Word Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 35,
                      title: 'Business',
                      color: Colors.blue,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 25,
                      title: 'Academic',
                      color: Colors.green,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Daily',
                      color: Colors.orange,
                      radius: 80,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Other',
                      color: Colors.purple,
                      radius: 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              icon: Icons.quiz,
              title: 'Completed Daily Quiz',
              subtitle: '1h ago',
              score: '9/10',
            ),
            _buildActivityItem(
              icon: Icons.add_circle,
              title: 'Added new words',
              subtitle: '3h ago',
              score: '+3',
            ),
            _buildActivityItem(
              icon: Icons.stars,
              title: 'Achieved 7-day streak',
              subtitle: '1d ago',
              score: '🏆',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String score,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        score,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildProgressTab() {
    // Implementation for Progress tab
    return Center(child: Text('Progress Tab - To be implemented'));
  }

  Widget _buildAchievementsTab() {
    // Implementation for Achievements tab
    return Center(child: Text('Achievements Tab - To be implemented'));
  }
}
