import 'package:flutter/material.dart';

class VocabularyList extends StatefulWidget {
  const VocabularyList({super.key});

  @override
  _VocabularyListState createState() => _VocabularyListState();
}

class _VocabularyListState extends State<VocabularyList> {
  String searchTerm = '';
  String selectedCategory = 'All';
  String selectedLevel = 'All';

  final List<String> categories = [
    'All',
    'Business',
    'Travel',
    'Technology',
    'Academic',
    'Daily Life',
  ];

  final List<String> levels = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<Map<String, dynamic>> vocabularyWords = [
    {
      'word': 'Accomplish',
      'translation': 'ينجز',
      'category': 'Business',
      'level': 'Intermediate',
      'example': 'She accomplished all her goals for the quarter.',
      'dateAdded': '2024-03-15',
      'tags': ['achievement', 'success'],
      'mastered': true,
    },
    {
      'word': 'Sustainable',
      'translation': 'مستدام',
      'category': 'Technology',
      'level': 'Advanced',
      'example': 'The company focuses on sustainable development.',
      'dateAdded': '2024-03-14',
      'tags': ['environment', 'business'],
      'mastered': false,
    },
  ];

  void _addNewWordDialog() {
    // Placeholder function to show dialog for adding a new word
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Word'),
        content: Text('Form to add a new word goes here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add new word logic here
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('My Vocabulary'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewWordDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Filter Section
            Row(
              children: [
                // Search Input
                /* Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) => setState(() {
                      searchTerm = value;
                    }),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search words...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
*/
                // Category Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (value) => setState(() {
                      selectedCategory = value!;
                    }),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),

                // Level Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedLevel,
                    onChanged: (value) => setState(() {
                      selectedLevel = value!;
                    }),
                    items: levels.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Vocabulary List
            Expanded(
              child: ListView.builder(
                itemCount: vocabularyWords.length,
                itemBuilder: (context, index) {
                  final word = vocabularyWords[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(word['word'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(word['translation'],
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text(word['example'],
                              style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 8.0),
                          Wrap(
                            spacing: 6.0,
                            children: [
                              Chip(
                                label: Text(word['category']),
                                backgroundColor: Colors.blue[100],
                                labelStyle: TextStyle(color: Colors.blue[800]),
                              ),
                              Chip(
                                label: Text(word['level']),
                                backgroundColor: Colors.purple[100],
                                labelStyle:
                                    TextStyle(color: Colors.purple[800]),
                              ),
                              ...word['tags'].map<Widget>((tag) => Chip(
                                    label: Text('#$tag'),
                                    backgroundColor: Colors.grey[200],
                                    labelStyle:
                                        TextStyle(color: Colors.grey[800]),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Edit word logic
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Delete word logic
                            },
                          ),
                        ],
                      ),
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
}

void main() => runApp(MaterialApp(
      home: VocabularyList(),
    ));
