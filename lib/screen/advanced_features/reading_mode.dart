import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:folder_notes/screen/advanced_features/word.dart'; // Ensure this file contains the Word class

class ReadingMode extends StatefulWidget {
  const ReadingMode({super.key});

  @override
  _ReadingModeState createState() => _ReadingModeState();
}

class _ReadingModeState extends State<ReadingMode> {
  bool showWordDialog = false;
  Word? selectedWord; // Selected word is now of type 'Word'
  List<Word> savedWords = []; // Saved words are now of type 'Word'

  final articleData = {
    "title": "The Future of Sustainable Technology",
    "author": "Sarah Johnson",
    "readingLevel": "Intermediate",
    "readingTime": "5 min",
    "content":
        '''Renewable energy technologies are becoming increasingly prevalent in our daily lives. The resilient nature of these systems ensures they can withstand various weather conditions. Many innovative solutions are emerging, making sustainable living more accessible to everyone.

  Scientists are developing pioneering methods to harness solar and wind power more efficiently. These groundbreaking technologies could revolutionize how we think about energy consumption. The implementation of these systems requires meticulous planning and expertise.

  As we progress towards a more sustainable future, the adaptation of these technologies becomes crucial. The transformation of our energy infrastructure presents both challenges and opportunities.''',
    "unknownWords": [
      Word(
          word: "resilient",
          translation: "مرن",
          definition: "Able to recover quickly from difficulties",
          frequency: "Common"),
      Word(
          word: "pioneering",
          translation: "ريادي",
          definition: "Introducing new methods or ideas",
          frequency: "Moderate"),
      Word(
          word: "meticulous",
          translation: "دقيق",
          definition: "Showing great attention to detail",
          frequency: "Advanced"),
    ]
  };

  // Handle word click
  void handleWordClick(Word word) {
    setState(() {
      selectedWord = word;
      showWordDialog = true;
    });
  }

  // Add word to saved vocabulary
  void addToVocabulary(Word word) {
    setState(() {
      savedWords.add(word);
      showWordDialog = false;
    });
  }

  // Function to highlight words in text
  Widget renderHighlightedText(String text) {
    List<TextSpan> spans = [];
    List<String> words = text.split(' ');

    for (String word in words) {
      // Check if the word matches any known word in the article
      final match = (articleData["unknownWords"] as List<Word>).firstWhere(
        (w) => word.contains(w.word),
        orElse: () =>
            Word(word: "", translation: "", definition: "", frequency: ""),
      );

      // If a match is found (i.e., the word isn't empty), highlight it
      if (match.word.isNotEmpty) {
        spans.add(TextSpan(
          text: "$word ",
          style: TextStyle(
            backgroundColor: Colors.yellow.shade100,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => handleWordClick(match),
        ));
      } else {
        spans.add(TextSpan(text: "$word "));
      }
    }

    return RichText(
      text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16), children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width using MediaQuery for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reading Mode'),
      ),
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView for overflow handling
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Header
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      articleData["title"] as String,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("By ${articleData["author"] as String}"),
                        SizedBox(width: 8),
                        Text("• ${articleData["readingTime"] as String} read"),
                        SizedBox(width: 8),
                        Text(
                            "• Level: ${articleData["readingLevel"] as String}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Reading Tools
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Text-to-Speech functionality here
                  },
                  child: Text("Text-to-Speech"),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // Adjust Text Size functionality here
                  },
                  child: Text("Adjust Text Size"),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Adjust layout to be responsive
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Content
                Expanded(
                  flex:
                      3, // Adjust the space for the content to take up 3/4 of the screen width on large devices
                  child: SingleChildScrollView(
                    // Add scrolling for the content
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: renderHighlightedText(
                            articleData["content"] as String),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Sidebar
                if (screenWidth >=
                    600) // Only show sidebar if screen width is large enough
                  Expanded(
                    flex:
                        2, // Sidebar takes up 2/4 of the screen width on large devices
                    child: SingleChildScrollView(
                      // Add scrolling for the sidebar content
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New Words",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              // Iterate through the unknown words and display them in the sidebar
                              ...((articleData["unknownWords"] as List<Word>?)
                                      ?.map<Widget>((word) {
                                    bool isSaved = savedWords.contains(word);
                                    return Container(
                                      padding: EdgeInsets.all(8.0),
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      decoration: BoxDecoration(
                                        color: isSaved
                                            ? Colors.green.shade50
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(word.word,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(word.translation,
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                          if (!isSaved)
                                            TextButton(
                                              onPressed: () =>
                                                  addToVocabulary(word),
                                              child: Text("Add",
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList() ??
                                  []),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Show Word Dialog if selectedWord is not null
            if (showWordDialog && selectedWord != null)
              AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedWord!.word),
                    Text("Frequency: ${selectedWord!.frequency}",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selectedWord!.translation,
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text(selectedWord!.definition,
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => addToVocabulary(selectedWord!),
                    child: Text("Add to Vocabulary"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => showWordDialog = false);
                    },
                    child: Text("Close"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
