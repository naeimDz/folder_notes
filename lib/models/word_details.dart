import 'custom_property.dart';
import 'definition.dart';
import 'validation_exception.dart';

class WordDetails {
  final List<Definition> definitions;
  final List<String> examples;

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
    this.examples = const [],
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
  WordDetails copyWith({
    List<Definition>? definitions,
    List<String>? examples,
    List<String>? synonyms,
    List<String>? antonyms,
    String? pronunciation,
    String? partOfSpeech,
    String? usageNotes,
    List<String>? collocations,
    String? audioUrl,
    String? imageUrl,
    Map<String, CustomProperty>? customProperties,
  }) {
    return WordDetails(
      definitions: definitions ?? this.definitions,
      examples: examples ?? this.examples,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      pronunciation: pronunciation ?? this.pronunciation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      usageNotes: usageNotes ?? this.usageNotes,
      collocations: collocations ?? this.collocations,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  void validate() {
    if (audioUrl != null && !Uri.tryParse(audioUrl!)!.isAbsolute) {
      throw ValidationException('Invalid audio URL');
    }
    if (imageUrl != null && !Uri.tryParse(imageUrl!)!.isAbsolute) {
      throw ValidationException('Invalid image URL');
    }

    for (var def in definitions) {
      def.validate();
    }

    // Validate custom properties
    for (var prop in customProperties.values) {
      prop.validate();
    }
  }

  Map<String, dynamic> toFirestore() {
    validate();
    return {
      'definitions': definitions.map((d) => d.toFirestore()).toList(),
      'examples': examples,
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
      examples: List<String>.from(data['examples'] ?? []),
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
// Helper method to add custom property
  WordDetails addCustomProperty(String name, dynamic value, String type) {
    final newProperties = Map<String, CustomProperty>.from(customProperties);
    newProperties[name] = CustomProperty(name: name, value: value, type: type);

    return WordDetails();
  }
}
