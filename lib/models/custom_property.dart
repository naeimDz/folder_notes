import 'package:cloud_firestore/cloud_firestore.dart';
import 'validation_exception.dart';

// Custom property model
class CustomProperty {
  final String name;
  final dynamic value;
  final String type; // 'text', 'number', 'date', 'list'

  CustomProperty({
    required this.name,
    required this.value,
    required this.type,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'value': value,
      'type': type,
    };
  }

  factory CustomProperty.fromFirestore(Map<String, dynamic> data) {
    return CustomProperty(
      name: data['name'],
      value: data['value'],
      type: data['type'],
    );
  }

  // Validation method
  void validate() {
    if (name.isEmpty) {
      throw ValidationException('Custom property name cannot be empty');
    }

    switch (type) {
      case 'number':
        if (value is! num) {
          throw ValidationException('Value must be a number for type "number"');
        }
        break;
      case 'date':
        if (value is! Timestamp && value is! DateTime) {
          throw ValidationException('Value must be a date for type "date"');
        }
        break;
      case 'list':
        if (value is! List) {
          throw ValidationException('Value must be a list for type "list"');
        }
        break;
    }
  }
}
