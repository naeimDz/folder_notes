// editWordProvider.dart
import 'package:flutter/foundation.dart';

import '../models/word.dart';

class EditWordProvider with ChangeNotifier {
  Word _editingWord = Word.empty();

  Word get editingWord => _editingWord;

  void startEditingWord(Word word) {
    _editingWord = word;
    notifyListeners();
  }

  Future<void> saveEditedWord(Word updatedWord) async {
    try {
      notifyListeners(); // Trigger any necessary UI updates
    } catch (error) {
      throw error;
    }
  }
}
