import 'package:flutter/material.dart';

class WordDetailScreen extends StatefulWidget {
  const WordDetailScreen({super.key});

  @override
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  bool isBookmarked = false;
  bool showFullDefinition = false;

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
    "mastery": {"level": "Learning", "accuracy": 75, "nextReview": "3 days"}
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wordData["word"] as String,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      wordData["phonetic"] as String,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    Text(
                      wordData["translation"] as String,
                      style: TextStyle(fontSize: 24, color: Colors.grey[800]),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.yellow[700] : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Play sound function
                      },
                      child: Text("Play Sound"),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Definition Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Definition",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(wordData["definition"] as String),
                    if (showFullDefinition)
                      Text(
                        wordData["extendedDefinition"] as String,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showFullDefinition = !showFullDefinition;
                        });
                      },
                      child:
                          Text(showFullDefinition ? 'Show Less' : 'Show More'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Examples Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Examples",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...(wordData["examples"] as List<Map<String, String>>)
                        .map<Widget>((example) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(example["english"] ?? ""),
                            SizedBox(height: 4),
                            Text(
                              example["arabic"] ?? "",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Synonyms & Antonyms
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Synonyms",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (wordData["synonyms"] as List<String>)
                                .map<Widget>((synonym) {
                              return Chip(
                                label: Text(synonym),
                                backgroundColor: Colors.green[100],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Antonyms",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (wordData["antonyms"] as List<String>)
                                .map<Widget>((antonym) {
                              return Chip(
                                label: Text(antonym),
                                backgroundColor: Colors.red[100],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Learning Progress Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Learning Progress",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quiz Accuracy"),
                            Text(
                                "${(wordData["mastery"] as Map<String, dynamic>)["accuracy"] ?? 0}%"), // Cast to Map<String, dynamic>
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Next Review"),
                            Text((wordData["mastery"]
                                    as Map<String, dynamic>)["nextReview"] ??
                                "N/A"), // Cast to Map<String, dynamic>
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add to Flashcards action
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple),
                    child: Text("Add to Flashcards"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Start Quick Quiz action
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("Start Quick Quiz"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
