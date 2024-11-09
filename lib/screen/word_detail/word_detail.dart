import 'package:flutter/material.dart';
import 'dart:math' as math;

class WordDetailScreen extends StatefulWidget {
  const WordDetailScreen({super.key});

  @override
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isBookmarked = false;
  bool showFullDefinition = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Sample word data
  final wordData = {
    "word": "Resilient",
    "translation": "مرن",
    "phonetic": "/rɪzɪliənt/",
    "definition": "Able to recover quickly from difficulties; tough.",
    "extendedDefinition":
        "Having the quality of being able to return to original form after being bent, compressed, or stretched. In a broader sense, it refers to the capacity to recover quickly from difficulties or challenges.",
    "examples": [
      {
        "english": "The resilient economy bounced back after the recession.",
        "arabic": "عاد الاقتصاد المرن إلى وضعه الطبيعي بعد الركود."
      },
      {
        "english": "She proved to be resilient in the face of adversity.",
        "arabic": "أثبتت أنها مرنة في مواجهة الشدائد."
      }
    ],
    "synonyms": ["tough", "adaptable", "flexible"],
    "antonyms": ["fragile", "weak", "inflexible"],
    "mastery": {"level": "Learning", "accuracy": 75, "nextReview": "3 days"},
    "difficulty": 3,
  };

  Widget _buildProgressIndicator(double value, Color color) {
    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCard({
    required String title,
    required Widget child,
    Color? backgroundColor,
    EdgeInsets? padding,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(int level) {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < level ? Colors.orange : Colors.grey[300],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                wordData["word"] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue[700]!,
                      Colors.blue[900]!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_animation.value * 0.2),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.yellow : Colors.white,
                      ),
                    );
                  },
                ),
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                    if (isBookmarked) {
                      _controller.forward(from: 0);
                    }
                  });
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wordData["translation"] as String,
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    wordData["phonetic"] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Play sound logic
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Colors.blue[700],
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDifficultyIndicator(
                              wordData["difficulty"] as int),
                        ],
                      ),
                    ),
                  ),

                  // Definition Section
                  _buildCustomCard(
                    title: "Definition",
                    backgroundColor: Colors.blue[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wordData["definition"] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (showFullDefinition) ...[
                          const SizedBox(height: 12),
                          Text(
                            wordData["extendedDefinition"] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showFullDefinition = !showFullDefinition;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                showFullDefinition ? 'Show Less' : 'Show More',
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                              Icon(
                                showFullDefinition
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.blue[700],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Examples Section
                  _buildCustomCard(
                    title: "Examples",
                    backgroundColor: Colors.green[50],
                    child: Column(
                      children: [
                        ...(wordData["examples"] as List<Map<String, String>>)
                            .map((example) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green[100]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  example["english"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  example["arabic"]!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  // Synonyms & Antonyms
                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomCard(
                          title: "Synonyms",
                          backgroundColor: Colors.green[50],
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (wordData["synonyms"] as List<String>)
                                .map((synonym) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  synonym,
                                  style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCustomCard(
                          title: "Antonyms",
                          backgroundColor: Colors.red[50],
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (wordData["antonyms"] as List<String>)
                                .map((antonym) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  antonym,
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Learning Progress
                  _buildCustomCard(
                    title: "Learning Progress",
                    backgroundColor: Colors.purple[50],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mastery Level",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    (wordData["mastery"]
                                            as Map<String, dynamic>)["level"]
                                        as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Next Review: ${(wordData["mastery"] as Map<String, dynamic>)["nextReview"]}",
                                style: TextStyle(
                                  color: Colors.purple[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quiz Accuracy",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${(wordData["mastery"] as Map<String, dynamic>)["accuracy"]}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildProgressIndicator(
                              (wordData["mastery"]
                                      as Map<String, dynamic>)["accuracy"]! /
                                  100.0, // Ensures it's a double
                              Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quick Actions Section
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        _buildActionButton(
                          icon: Icons.school,
                          label: "Practice with Flashcards",
                          color: Colors.purple,
                          onPressed: () {
                            // Add to Flashcards action
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.quiz,
                          label: "Take Quick Quiz",
                          color: Colors.green,
                          onPressed: () {
                            // Start Quick Quiz action
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.record_voice_over,
                          label: "Practice Pronunciation",
                          color: Colors.blue,
                          onPressed: () {
                            // Practice pronunciation action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add to study list action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to study list'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Undo action
                },
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add to Study List'),
        backgroundColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
