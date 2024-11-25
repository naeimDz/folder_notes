import 'custom_property.dart';
import 'validation_exception.dart';

class ExtraDefinition {
  final String meaning;
  final String example;
  final Map<String, CustomProperty> customProperties;

  ExtraDefinition({
    required this.meaning,
    required this.example,
    this.customProperties = const {},
  });

  void validate() {
    if (meaning.isEmpty) {
      throw ValidationException('Definition meaning cannot be empty');
    }
    if (example.isEmpty) {
      throw ValidationException('Definition example cannot be empty');
    }
    customProperties.values.forEach((prop) => prop.validate());
  }

  Map<String, dynamic> toFirestore() {
    validate();
    return {
      'meaning': meaning,
      'example': example,
      'customProperties': customProperties
          .map((key, value) => MapEntry(key, value.toFirestore())),
    };
  }

  factory ExtraDefinition.fromFirestore(Map<String, dynamic> data) {
    final definition = ExtraDefinition(
      meaning: data['meaning'] ?? '',
      example: data['example'] ?? '',
      customProperties: (data['customProperties'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    key,
                    CustomProperty.fromFirestore(value as Map<String, dynamic>),
                  )) ??
          {},
    );

    definition.validate();
    return definition;
  }
}
