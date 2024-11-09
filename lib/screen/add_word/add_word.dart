import 'package:flutter/material.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({Key? key}) : super(key: key);

  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  // Track visibility of different sections
  bool showWordDetails = true;
  bool showDefinition = false;
  bool showExamples = false;
  bool showSynonymsAntonyms = false;
  bool showTags = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Word'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word Details Section with Icon to toggle visibility
            _buildSection(
              title: 'Word Details',
              showSection: showWordDetails,
              toggleVisibility: () {
                setState(() {
                  showWordDetails = !showWordDetails;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(label: "Word", hint: "Enter the word"),
                  _buildTextField(
                      label: "Translation", hint: "Enter translation"),
                  _buildTextField(
                      label: "Phonetic", hint: "Enter phonetic transcription"),
                ],
              ),
            ),

            // Definition Section
            _buildSection(
              title: 'Definition',
              showSection: showDefinition,
              toggleVisibility: () {
                setState(() {
                  showDefinition = !showDefinition;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: "Definition",
                    hint: "Enter a brief definition",
                    maxLines: 3,
                  ),
                  _buildTextField(
                    label: "Extended Definition",
                    hint: "Enter a more detailed explanation",
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            // Examples Section
            _buildSection(
              title: 'Examples',
              showSection: showExamples,
              toggleVisibility: () {
                setState(() {
                  showExamples = !showExamples;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: "Example 1 (English)",
                    hint: "Enter example in English",
                  ),
                  _buildTextField(
                    label: "Example 1 (Arabic)",
                    hint: "Enter example in Arabic",
                  ),
                  const Divider(),
                  _buildTextField(
                    label: "Example 2 (English)",
                    hint: "Enter example in English",
                  ),
                  _buildTextField(
                    label: "Example 2 (Arabic)",
                    hint: "Enter example in Arabic",
                  ),
                ],
              ),
            ),

            // Synonyms and Antonyms Section
            _buildSection(
              title: 'Synonyms & Antonyms',
              showSection: showSynonymsAntonyms,
              toggleVisibility: () {
                setState(() {
                  showSynonymsAntonyms = !showSynonymsAntonyms;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: "Synonyms",
                    hint: "Enter synonyms separated by commas",
                  ),
                  _buildTextField(
                    label: "Antonyms",
                    hint: "Enter antonyms separated by commas",
                  ),
                ],
              ),
            ),

            // Tags Section
            _buildSection(
              title: 'Tags',
              showSection: showTags,
              toggleVisibility: () {
                setState(() {
                  showTags = !showTags;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: "Tags",
                    hint: "Enter tags separated by commas",
                  ),
                ],
              ),
            ),

            // Save and Cancel Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Save function here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16)),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Cancel function here
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each collapsible section with toggle functionality
  Widget _buildSection({
    required String title,
    required bool showSection,
    required VoidCallback toggleVisibility,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    showSection ? Icons.remove_circle : Icons.add_circle,
                    color: Colors.blue,
                  ),
                  onPressed: toggleVisibility,
                ),
              ],
            ),
            if (showSection) child,
          ],
        ),
      ),
    );
  }

  // Helper function to build input fields with labels
  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
