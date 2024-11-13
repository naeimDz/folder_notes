// screens/add_word_screen.dart
import 'package:flutter/material.dart';
import 'package:my_lab/models/word.dart';
import 'package:provider/provider.dart';

import '../../providers/word_provider.dart';

class AddWordScreenTest extends StatefulWidget {
  const AddWordScreenTest({super.key});

  @override
  _AddWordScreenTestState createState() => _AddWordScreenTestState();
}

class _AddWordScreenTestState extends State<AddWordScreenTest> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  final _definitionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Word'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<WordProvider>(
        builder: (context, wordProvider, child) {
          if (wordProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Word Field
                  TextFormField(
                    controller: _wordController,
                    decoration: const InputDecoration(
                      labelText: 'Word',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter a word' : null,
                  ),
                  const SizedBox(height: 16),

                  // Translation Field
                  TextFormField(
                    controller: _translationController,
                    decoration: const InputDecoration(
                      labelText: 'Translation',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a translation'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Definition Field
                  TextFormField(
                    controller: _definitionController,
                    decoration: const InputDecoration(
                      labelText: 'Definition',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a definition'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Error Message
                  if (wordProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        wordProvider.error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),

                  // Save Button
                  ElevatedButton(
                    onPressed: _saveWord,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Word'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveWord() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        Word newWord = Word(
            id: "id",
            word: _wordController.text,
            translation: _translationController.text,
            definition: _definitionController.text,
            dateAdded: DateTime.timestamp());
        await context.read<WordProvider>().addWord(newWord);
        Navigator.pushNamed(context, "/word-list");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _definitionController.dispose();
    super.dispose();
  }
}
