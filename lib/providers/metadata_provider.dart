import 'package:flutter/material.dart';
import '../controller/metadata_controller.dart';

// WordCountProvider to manage word count
class MetadataProvider extends ChangeNotifier {
  final MetadataController _controller = MetadataController();

  int _wordCount = 0;
  bool _isLoading = false;
  String? _error;

  //////////
  int get wordCount => _wordCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MetadataProvider() {
    fetchWordCount();
  }
  // Fetch count from Firestore
  Future<void> fetchWordCount() async {
    _setLoading(true);

    try {
      _controller.getWordsCount().then(
        (value) {
          _wordCount = value;
          notifyListeners();
        },
        onError: (e) => _setError(e.toString()),
      );
    } catch (e) {
      print('Error fetching word count: $e');
      _wordCount = 0;
      notifyListeners();
    }
  }

  // Update the word count (add or remove)
  Future<void> updateWordCount({bool decrement = false}) async {
    try {
      _controller.updateDocumentCount(decrement: decrement).then((value) {
        _wordCount = value;
        notifyListeners();
      });
      // Notify UI about state change
    } catch (e) {
      print('Error updating word count: $e');
    }
  }

  // Helper Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
