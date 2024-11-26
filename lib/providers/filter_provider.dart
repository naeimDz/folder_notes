import 'package:flutter/foundation.dart';

class FilterProvider extends ChangeNotifier {
  // List of filters and their selection states
  final Map<String, bool> _filters = {
    'All Words': true,
    'Favorites': false,
    'Recent': false,
    'Mastered': false,
    'Alphabetical': false,
    'Mastery Level': false,
  };

  Map<String, bool> get filters => _filters;

  void toggleFilter(String filter) {
    // Reset all filters for single selection, or implement multi-select logic
    _filters.updateAll((key, value) => false);
    _filters[filter] = true;

    notifyListeners(); // Notify UI about state change
  }
}
