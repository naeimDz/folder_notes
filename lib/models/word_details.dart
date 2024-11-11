import 'custom_property.dart';
import 'definition.dart';
import 'validation_exception.dart';

class WordDetails {
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;
  final String pronunciation;
  final String partOfSpeech;
  final String usageNotes;
  final List<String> collocations;
  final String? audioUrl;
  final String? imageUrl;
  final Map<String, CustomProperty> customProperties;

  WordDetails({
    this.definitions = const [],
    this.synonyms = const [],
    this.antonyms = const [],
    this.pronunciation = '',
    this.partOfSpeech = '',
    this.usageNotes = '',
    this.collocations = const [],
    this.audioUrl,
    this.imageUrl,
    this.customProperties = const {},
  });

  void validate() {
    if (audioUrl != null && !Uri.tryParse(audioUrl!)!.isAbsolute) {
      throw ValidationException('Invalid audio URL');
    }
    if (imageUrl != null && !Uri.tryParse(imageUrl!)!.isAbsolute) {
      throw ValidationException('Invalid image URL');
    }

    definitions.forEach((def) => def.validate());
    customProperties.values.forEach((prop) => prop.validate());
  }

  Map<String, dynamic> toFirestore() {
    validate();
    return {
      'definitions': definitions.map((d) => d.toFirestore()).toList(),
      'synonyms': synonyms,
      'antonyms': antonyms,
      'pronunciation': pronunciation,
      'partOfSpeech': partOfSpeech,
      'usageNotes': usageNotes,
      'collocations': collocations,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'customProperties': customProperties
          .map((key, value) => MapEntry(key, value.toFirestore())),
    };
  }

  factory WordDetails.fromFirestore(Map<String, dynamic> data) {
    final details = WordDetails(
      definitions: (data['definitions'] as List?)
              ?.map((d) => Definition.fromFirestore(d))
              .toList() ??
          [],
      synonyms: List<String>.from(data['synonyms'] ?? []),
      antonyms: List<String>.from(data['antonyms'] ?? []),
      pronunciation: data['pronunciation'] ?? '',
      partOfSpeech: data['partOfSpeech'] ?? '',
      usageNotes: data['usageNotes'] ?? '',
      collocations: List<String>.from(data['collocations'] ?? []),
      audioUrl: data['audioUrl'],
      imageUrl: data['imageUrl'],
      customProperties: (data['customProperties'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    key,
                    CustomProperty.fromFirestore(value as Map<String, dynamic>),
                  )) ??
          {},
    );

    details.validate();
    return details;
  }
}
