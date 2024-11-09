import 'package:flutter/material.dart';

class SpacedRepetitionPractice extends StatefulWidget {
  const SpacedRepetitionPractice({super.key});

  @override
  _SpacedRepetitionPracticeState createState() =>
      _SpacedRepetitionPracticeState();
}

class _SpacedRepetitionPracticeState extends State<SpacedRepetitionPractice> {
  String currentMode = 'preview'; // preview, practice, summary
  int currentWordIndex = 0;
  bool showAnswer = false;
  double sessionProgress = 0;
  List<Map<String, dynamic>> responses = [];

  final sessionData = {
    "totalWords": 20,
    "dueToday": 15,
    "streak": 7,
    "reviewSchedule": [
      {"interval": "1 day", "count": 5},
      {"interval": "3 days", "count": 8},
      {"interval": "1 week", "count": 7},
    ]
  };

  final List<Map<String, dynamic>> practiceWords = [
    {
      "id": 1,
      "word": "Perseverance",
      "translation": "المثابرة",
      "definition": "Persistence in doing something despite difficulty",
      "context": "Her perseverance in studying led to excellent results.",
      "lastReviewed": "3 days ago",
      "difficulty": "medium",
      "nextReview": "2 days",
      "synonyms": ["persistence", "determination", "tenacity"],
      "mastery": 0.7,
    },
    // Additional practice words can be added here
  ];

  void handleResponse(String response) {
    setState(() {
      responses.add({
        "wordId": practiceWords[currentWordIndex]["id"],
        "response": response
      });
      showAnswer = false;
      sessionProgress = (currentWordIndex + 1) / practiceWords.length * 100;
      if (currentWordIndex < practiceWords.length - 1) {
        currentWordIndex++;
      } else {
        currentMode = 'summary';
      }
    });
  }

  Widget previewSection() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Today's Review Session",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Words Due Today",
                        style: TextStyle(color: Colors.blue)),
                    Text("${sessionData["dueToday"]}",
                        style: TextStyle(fontSize: 32, color: Colors.blue)),
                  ],
                ),
                Column(
                  children: [
                    Text("Current Streak",
                        style: TextStyle(color: Colors.green)),
                    Text("${sessionData["streak"]} days",
                        style: TextStyle(fontSize: 32, color: Colors.green)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Review Schedule",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...(sessionData["reviewSchedule"] as List<Map<String, dynamic>>)
                .map<Widget>((schedule) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(schedule["interval"]),
                  Text("${schedule["count"]} words",
                      style: TextStyle(color: Colors.grey)),
                ],
              );
            }),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => currentMode = 'practice'),
              child: Text("Start Review Session"),
            ),
          ],
        ),
      ),
    );
  }

  Widget practiceSection() {
    final currentWord = practiceWords[currentWordIndex];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(value: sessionProgress / 100),
              SizedBox(height: 16),
              Text("${currentWordIndex + 1} of ${practiceWords.length}"),
              SizedBox(height: 8),
              Text("${sessionProgress.toInt()}% Complete"),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(currentWord["word"],
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (showAnswer) ...[
                  SizedBox(height: 8),
                  Text(currentWord["translation"],
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                  Text(currentWord["definition"], textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  Text("\"${currentWord["context"]}\"",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: currentWord["synonyms"].map<Widget>((syn) {
                      return Chip(
                          label:
                              Text(syn, style: TextStyle(color: Colors.blue)));
                    }).toList(),
                  ),
                ],
                SizedBox(height: 16),
                if (!showAnswer)
                  ElevatedButton(
                    onPressed: () => setState(() => showAnswer = true),
                    child: Text("Show Answer"),
                  ),
                if (showAnswer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => handleResponse("hard"),
                        child: Text("Hard"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow),
                        onPressed: () => handleResponse("medium"),
                        child: Text("Medium"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () => handleResponse("easy"),
                        child: Text("Easy"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget summarySection() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Session Complete!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard("Easy", Colors.green,
                    responses.where((r) => r["response"] == "easy").length),
                _buildSummaryCard("Medium", Colors.yellow,
                    responses.where((r) => r["response"] == "medium").length),
                _buildSummaryCard("Hard", Colors.red,
                    responses.where((r) => r["response"] == "hard").length),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentMode = 'preview';
                  currentWordIndex = 0;
                  responses.clear();
                  sessionProgress = 0;
                });
              },
              child: Text("Start New Session"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, Color color, int count) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color)),
        Text("$count", style: TextStyle(fontSize: 32, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spaced Repetition Practice")),
      body: currentMode == 'preview'
          ? previewSection()
          : currentMode == 'practice'
              ? practiceSection()
              : summarySection(),
    );
  }
}
