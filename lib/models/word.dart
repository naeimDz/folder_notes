class Word {
  final int id;
  final String word;
  final String translation;
  final String definition;
  final String context;
  final String lastReviewed;
  final String difficulty;
  final String nextReview;
  final List<String> synonyms;
  final List<String> tags;
  final String category;
  double masteryScore;

  // Optional properties with default values
  final String usageFrequency;
  final String pronunciation;
  final String partOfSpeech;
  final String etymology;
  final List<String> regionalVariants;
  final String formality;
  final int frequencyScore;
  final List<String> relatedWords;
  final List<String> examples;
  final String usageNotes;
  final String mnemonic;
  final String culturalReferences;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    required this.definition,
    required this.context,
    required this.lastReviewed,
    required this.difficulty,
    required this.nextReview,
    required this.synonyms,
    required this.tags,
    required this.category,
    this.masteryScore = 0.0,
    this.usageFrequency = '',
    this.pronunciation = '',
    this.partOfSpeech = '',
    this.etymology = '',
    this.regionalVariants = const [],
    this.formality = 'Neutral',
    this.frequencyScore = 5,
    this.relatedWords = const [],
    this.examples = const [],
    this.usageNotes = '',
    this.mnemonic = '',
    this.culturalReferences = '',
  });
}

final List<Word> practiceWords = [
  Word(
    id: 1,
    word: "Which",
    translation: "الذي",
    definition: "Used referring to something previously mentioned.",
    context: "She couldn't decide which color suited her best.",
    lastReviewed: "1 day ago",
    difficulty: "easy",
    nextReview: "3 days",
    synonyms: ["that", "whichever"],
    tags: ["relative pronoun", "choice"],
    category: "Grammar",
    masteryScore: 0.7,
  ),
  Word(
    id: 2,
    word: "Even",
    translation: "حتى",
    definition: "Used to emphasize something surprising or unexpected.",
    context: "He worked even harder after his promotion.",
    lastReviewed: "2 days ago",
    difficulty: "medium",
    nextReview: "5 days",
    synonyms: ["indeed", "still", "yet"],
    tags: ["emphasis", "intensity"],
    category: "Adverbs",
    masteryScore: 0.5,
  ),
  Word(
    id: 3,
    word: "Instead",
    translation: "بدلاً من ذلك",
    definition: "As an alternative or substitute.",
    context: "She decided to walk instead of taking the bus.",
    lastReviewed: "3 days ago",
    difficulty: "medium",
    nextReview: "4 days",
    synonyms: ["rather", "alternatively"],
    tags: ["substitution", "alternatives"],
    category: "Adverbs",
    masteryScore: 0.6,
  ),
  Word(
    id: 4,
    word: "Nevertheless",
    translation: "ومع ذلك",
    definition: "In spite of that; notwithstanding.",
    context: "He was tired; nevertheless, he continued working.",
    lastReviewed: "4 days ago",
    difficulty: "hard",
    nextReview: "1 week",
    synonyms: ["nonetheless", "even so"],
    tags: ["contrast", "transition"],
    category: "Conjunctions",
    masteryScore: 0.4,
  ),
  Word(
    id: 5,
    word: "Although",
    translation: "على الرغم من",
    definition: "In spite of the fact that; even though.",
    context: "Although it was raining, they went for a walk.",
    lastReviewed: "2 days ago",
    difficulty: "medium",
    nextReview: "3 days",
    synonyms: ["though", "even though"],
    tags: ["concession", "condition"],
    category: "Conjunctions",
    masteryScore: 0.65,
  ),
  Word(
    id: 6,
    word: "Therefore",
    translation: "لذلك",
    definition: "For that reason; consequently.",
    context: "He was late, therefore he missed the train.",
    lastReviewed: "5 days ago",
    difficulty: "easy",
    nextReview: "1 day",
    synonyms: ["hence", "thus"],
    tags: ["cause", "result"],
    category: "Transition Words",
    masteryScore: 0.8,
  ),
  Word(
    id: 7,
    word: "Furthermore",
    translation: "علاوة على ذلك",
    definition: "In addition; besides.",
    context: "She is smart; furthermore, she works hard.",
    lastReviewed: "1 week ago",
    difficulty: "hard",
    nextReview: "1 week",
    synonyms: ["moreover", "additionally"],
    tags: ["addition", "transition"],
    category: "Transition Words",
    masteryScore: 0.55,
  ),
  Word(
    id: 8,
    word: "Despite",
    translation: "على الرغم من",
    definition: "Without being affected by.",
    context: "Despite the cold, they went hiking.",
    lastReviewed: "3 days ago",
    difficulty: "medium",
    nextReview: "6 days",
    synonyms: ["in spite of", "notwithstanding"],
    tags: ["contrast", "condition"],
    category: "Prepositions",
    masteryScore: 0.5,
  ),
  Word(
    id: 9,
    word: "Because",
    translation: "لأن",
    definition: "For the reason that; since.",
    context: "She studied hard because she wanted to succeed.",
    lastReviewed: "1 day ago",
    difficulty: "easy",
    nextReview: "2 days",
    synonyms: ["since", "as"],
    tags: ["cause", "reason"],
    category: "Conjunctions",
    masteryScore: 0.9,
  ),
  Word(
    id: 10,
    word: "However",
    translation: "لكن",
    definition: "Used to introduce a contrast or contradiction.",
    context: "She was tired; however, she continued her studies.",
    lastReviewed: "4 days ago",
    difficulty: "medium",
    nextReview: "3 days",
    synonyms: ["but", "yet"],
    tags: ["contrast", "transition"],
    category: "Transition Words",
    masteryScore: 0.6,
  ),
];

final List<Word> vocabularyWords = [
  Word(
    id: 1,
    word: 'Acumen',
    translation: 'فطنة',
    definition: 'The ability to make good judgments and quick decisions.',
    context: 'She was praised for her business acumen.',
    lastReviewed: '2 days ago',
    difficulty: 'Advanced',
    nextReview: '2024-11-15',
    synonyms: ['insight', 'sharpness'],
    tags: ['business', 'intelligence'],
    category: 'Business',
    pronunciation: '/ˈakyəmən/',
    partOfSpeech: 'Noun',
    formality: 'Formal',
    examples: [
      'Her acumen in financial management led to the company’s success.',
      'Political acumen is crucial for leadership.'
    ],
  ),
  Word(
    id: 2,
    word: 'Empathy',
    translation: 'تعاطف',
    definition: 'The ability to understand and share the feelings of others.',
    context: 'Empathy is essential in healthcare.',
    lastReviewed: '5 days ago',
    difficulty: 'Intermediate',
    nextReview: '2024-11-18',
    synonyms: ['compassion', 'understanding'],
    tags: ['psychology', 'emotion'],
    category: 'Daily Life',
    mnemonic: 'Think "em" for "emotion" and "path" for "feeling path."',
  ),
  Word(
    id: 3,
    word: 'Algorithm',
    translation: 'خوارزمية',
    definition:
        'A process or set of rules to be followed in calculations or problem-solving.',
    context: 'Algorithms are fundamental in computer science.',
    lastReviewed: '7 days ago',
    difficulty: 'Advanced',
    nextReview: '2024-11-19',
    synonyms: ['procedure', 'formula'],
    tags: ['technology', 'math'],
    category: 'Technology',
    examples: [
      'An algorithm for sorting data is essential for software development.',
      'Google’s search algorithm influences information ranking.'
    ],
    usageNotes: 'Often used in computing and data science.',
  ),
  Word(
    id: 4,
    word: 'Precedent',
    translation: 'سابقة',
    definition:
        'An earlier event or action that serves as an example or guide.',
    context: 'The ruling set an important legal precedent.',
    lastReviewed: '4 days ago',
    difficulty: 'Advanced',
    nextReview: '2024-11-20',
    synonyms: ['example', 'model'],
    tags: ['law', 'history'],
    category: 'Academic',
    formality: 'Formal',
  ),
  Word(
    id: 5,
    word: 'Resilient',
    translation: 'مرن',
    definition:
        'Able to withstand or recover quickly from difficult conditions.',
    context: 'The community was resilient after the natural disaster.',
    lastReviewed: '1 day ago',
    difficulty: 'Intermediate',
    nextReview: '2024-11-12',
    synonyms: ['strong', 'tough'],
    tags: ['psychology', 'strength'],
    category: 'Daily Life',
    examples: [
      'Resilient materials are used in construction for durability.',
      'He remained resilient despite many setbacks.'
    ],
  ),
  Word(
    id: 6,
    word: 'Skeptical',
    translation: 'مشكوک',
    definition: 'Not easily convinced; having doubts.',
    context: 'The scientist was skeptical about the study’s findings.',
    lastReviewed: '6 days ago',
    difficulty: 'Intermediate',
    nextReview: '2024-11-16',
    synonyms: ['doubtful', 'cynical'],
    tags: ['psychology', 'critical thinking'],
    category: 'Academic',
  ),
  Word(
    id: 7,
    word: 'Conscientious',
    translation: 'ضمير حي',
    definition: 'Wishing to do one’s work well and thoroughly.',
    context: 'Her conscientious work made her a valuable employee.',
    lastReviewed: '3 days ago',
    difficulty: 'Advanced',
    nextReview: '2024-11-14',
    synonyms: ['careful', 'meticulous'],
    tags: ['work ethic', 'character'],
    category: 'Business',
    etymology: 'From Latin conscientia (knowledge within oneself).',
  ),
  Word(
    id: 8,
    word: 'Paradox',
    translation: 'مفارقة',
    definition: 'A statement that seems contradictory but may reveal a truth.',
    context: 'The paradox of freedom is that it requires responsibility.',
    lastReviewed: '10 days ago',
    difficulty: 'Advanced',
    nextReview: '2024-11-22',
    synonyms: ['contradiction', 'puzzle'],
    tags: ['philosophy', 'literature'],
    category: 'Academic',
  ),
  Word(
    id: 9,
    word: 'Versatile',
    translation: 'متعدد الجوانب',
    definition: 'Able to adapt to many different functions or activities.',
    context: 'A versatile tool is useful in many tasks.',
    lastReviewed: '8 days ago',
    difficulty: 'Intermediate',
    nextReview: '2024-11-17',
    synonyms: ['adaptable', 'flexible'],
    tags: ['skills', 'adaptability'],
    category: 'Daily Life',
    relatedWords: ['multifaceted', 'resourceful'],
  ),
  Word(
    id: 10,
    word: 'Camaraderie',
    translation: 'رفقة',
    definition:
        'Mutual trust and friendship among people who spend time together.',
    context: 'The team felt a strong sense of camaraderie.',
    lastReviewed: '12 days ago',
    difficulty: 'Advanced',
    nextReview: '2024-11-23',
    synonyms: ['fellowship', 'companionship'],
    tags: ['social', 'friendship'],
    category: 'Daily Life',
    formality: 'Neutral',
  ),
];