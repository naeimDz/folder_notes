import 'custom_property.dart';
import 'validation_exception.dart';

class Definition {
  final String meaning;
  final String example;
  final String? partOfSpeech;
  final Map<String, CustomProperty> customProperties;

  Definition({
    required this.meaning,
    required this.example,
    this.partOfSpeech,
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
      'partOfSpeech': partOfSpeech,
      'customProperties': customProperties
          .map((key, value) => MapEntry(key, value.toFirestore())),
    };
  }

  factory Definition.fromFirestore(Map<String, dynamic> data) {
    final definition = Definition(
      meaning: data['meaning'] ?? '',
      example: data['example'] ?? '',
      partOfSpeech: data['partOfSpeech'],
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
