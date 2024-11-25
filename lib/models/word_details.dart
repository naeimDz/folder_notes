import 'custom_property.dart';
import 'definition.dart';
import 'validation_exception.dart';

class WordDetails {
  final List<ExtraDefinition> extraDefinitions;
  final String definition;
  final String example;
  final List<String> tags;
  final List<String> synonyms;
  final List<String> antonyms;
  final String partOfSpeech;
  final String contextNotes;
  final List<String> lexicalRelations;

  final String? audioUrl;
  final String? imageUrl;
  final Map<String, CustomProperty> customProperties;

  WordDetails({
    this.extraDefinitions = const [],
    this.definition = "",
    this.example = "",
    this.tags = const [],
    this.synonyms = const [],
    this.antonyms = const [],
    this.partOfSpeech = '',
    this.contextNotes = '',
    this.lexicalRelations = const [],
    this.audioUrl,
    this.imageUrl,
    this.customProperties = const {},
  });
  WordDetails copyWith({
    List<ExtraDefinition>? extraDefinitions,
    String? example,
    String? definition,
    List<String>? tags,
    List<String>? synonyms,
    List<String>? antonyms,
    String? pronunciation,
    String? partOfSpeech,
    String? contextNotes,
    List<String>? lexicalRelations,
    String? audioUrl,
    String? imageUrl,
    Map<String, CustomProperty>? customProperties,
  }) {
    return WordDetails(
      extraDefinitions: extraDefinitions ?? this.extraDefinitions,
      definition: definition ?? this.definition,
      example: example ?? this.example,
      tags: tags ?? this.tags,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      contextNotes: contextNotes ?? this.contextNotes,
      lexicalRelations: lexicalRelations ?? this.lexicalRelations,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  factory WordDetails.empty() {
    return WordDetails(
        antonyms: [""],
        synonyms: [""],
        tags: [""],
        partOfSpeech: "",
        contextNotes: "");
  }

  void validate() {
    if (audioUrl != null && !Uri.tryParse(audioUrl!)!.isAbsolute) {
      throw ValidationException('Invalid audio URL');
    }
    if (imageUrl != null && !Uri.tryParse(imageUrl!)!.isAbsolute) {
      throw ValidationException('Invalid image URL');
    }

    for (var def in extraDefinitions) {
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
      'extraDefinitionss':
          extraDefinitions.map((d) => d.toFirestore()).toList(),
      'definition': definition,
      'example': example,
      'tags': tags,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'partOfSpeech': partOfSpeech,
      'contextNotes': contextNotes,
      'lexicalRelations': lexicalRelations,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'customProperties': customProperties
          .map((key, value) => MapEntry(key, value.toFirestore())),
    };
  }

  factory WordDetails.fromFirestore(Map<String, dynamic> data) {
    final details = WordDetails(
      extraDefinitions: (data['extraDefinitions'] as List?)
              ?.map((d) => ExtraDefinition.fromFirestore(d))
              .toList() ??
          [],
      definition: data['definition'] ?? '',
      example: data['example'] ?? "",
      tags: List<String>.from(data['tags'] ?? []),
      synonyms: List<String>.from(data['synonyms'] ?? []),
      antonyms: List<String>.from(data['antonyms'] ?? []),
      partOfSpeech: data['partOfSpeech'] ?? '',
      contextNotes: data['contextNotes'] ?? '',
      lexicalRelations: List<String>.from(data['lexicalRelations'] ?? []),
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
