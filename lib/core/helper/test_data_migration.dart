import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/word.dart';
import '../../models/word_details.dart';

class TestDataMigration {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> migrateTestData() async {
    try {
      // Check if data already exists
      final snapshot = await _firestore.collection('words').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Test data already exists. Skipping migration.');
        return;
      }

      final List<Word> testWords = [
        Word(
          id: '1',
          word: 'ubiquitous',
          translation: 'شائع',
          definition: 'present, appearing, or found everywhere',
          dateAdded: DateTime.now().subtract(Duration(days: 30)),
          lastReviewed: DateTime.now().subtract(Duration(days: 2)),
          isFavorite: true,
          examples: [
            'Mobile phones have become ubiquitous in modern society.',
            'Wi-Fi networks are now ubiquitous in urban areas.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['academic', 'formal', 'technology'],
          masteryScore: 85.0,
          reviewStatus: ReviewStatus.mastered,
          details: WordDetails(
            definitions: [],
            synonyms: ['omnipresent', 'widespread', 'universal'],
            antonyms: ['rare', 'scarce', 'uncommon'],
            pronunciation: 'yoo-BIK-wi-tuhs',
            partOfSpeech: 'adjective',
            usageNotes: 'Often used in academic and technical contexts',
            collocations: ['ubiquitous computing', 'ubiquitous presence'],
          ),
        ),
        Word(
          id: '2',
          word: 'ephemeral',
          translation: 'زائل',
          definition: 'lasting for a very short time',
          dateAdded: DateTime.now().subtract(Duration(days: 25)),
          lastReviewed: DateTime.now().subtract(Duration(days: 1)),
          isFavorite: false,
          examples: [
            'Social media stories are ephemeral, lasting only 24 hours.',
            'The beauty of cherry blossoms is ephemeral.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['nature', 'literary', 'time'],
          masteryScore: 65.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            definitions: [],
            synonyms: ['fleeting', 'temporary', 'transient'],
            antonyms: ['permanent', 'lasting', 'eternal'],
            pronunciation: 'ih-FEM-er-ul',
            partOfSpeech: 'adjective',
            usageNotes: 'Often used in poetry and literature',
            collocations: ['ephemeral beauty', 'ephemeral nature'],
          ),
        ),
        Word(
          id: '3',
          word: 'serendipity',
          translation: 'حسن الحظ',
          definition:
              'the occurrence and development of events by chance in a happy or beneficial way',
          dateAdded: DateTime.now().subtract(Duration(days: 20)),
          examples: [
            'Finding his dream job was pure serendipity.',
            'Many scientific discoveries happen by serendipity.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['positive', 'events', 'fortune'],
          masteryScore: 45.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['chance', 'fortune', 'luck'],
            pronunciation: 'ser-uhn-DIP-i-tee',
            partOfSpeech: 'noun',
            usageNotes: 'Often used to describe fortunate coincidences',
          ),
        ),
        Word(
          id: '4',
          word: 'paradigm',
          translation: 'نموذج',
          definition: 'a typical example or pattern of something',
          dateAdded: DateTime.now().subtract(Duration(days: 15)),
          examples: [
            'This discovery represents a paradigm shift in our understanding.',
            'The company became a paradigm of successful innovation.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['academic', 'concept', 'model'],
          masteryScore: 30.0,
          reviewStatus: ReviewStatus.newAdded,
          details: WordDetails(
            synonyms: ['model', 'pattern', 'example'],
            pronunciation: 'PAIR-uh-dime',
            partOfSpeech: 'noun',
            usageNotes: 'Commonly used in academic and scientific contexts',
          ),
        ),
        Word(
          id: '5',
          word: 'resilient',
          translation: 'مرن',
          definition:
              'able to withstand or recover quickly from difficult conditions',
          dateAdded: DateTime.now().subtract(Duration(days: 10)),
          examples: [
            'Children are often remarkably resilient.',
            'The economy proved resilient despite the crisis.'
          ],
          difficulty: Difficulty.beginner,
          tags: ['character', 'strength', 'psychology'],
          masteryScore: 90.0,
          reviewStatus: ReviewStatus.mastered,
          details: WordDetails(
            synonyms: ['tough', 'adaptable', 'flexible'],
            antonyms: ['fragile', 'weak', 'vulnerable'],
            pronunciation: 'ri-ZIL-yent',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '6',
          word: 'ameliorate',
          translation: 'تحسين',
          definition: 'to make something better or improve',
          dateAdded: DateTime.now().subtract(Duration(days: 40)),
          lastReviewed: DateTime.now().subtract(Duration(days: 5)),
          isFavorite: false,
          examples: [
            'The new policies aim to ameliorate living conditions.',
            'Efforts to ameliorate the situation were well-received.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['improvement', 'positive', 'formal'],
          masteryScore: 70.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['improve', 'enhance', 'better'],
            antonyms: ['worsen', 'degrade', 'deteriorate'],
            pronunciation: 'uh-MEEL-yuh-rayt',
            partOfSpeech: 'verb',
            usageNotes: 'Often used in formal and academic contexts',
            collocations: ['ameliorate conditions', 'ameliorate health'],
          ),
        ),
        Word(
          id: '7',
          word: 'tenacious',
          translation: 'عنيد',
          definition: 'holding firmly to something; very determined',
          dateAdded: DateTime.now().subtract(Duration(days: 35)),
          examples: [
            'She was tenacious in her pursuit of the truth.',
            'A tenacious athlete never gives up.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['determination', 'character', 'strength'],
          masteryScore: 60.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['persistent', 'determined', 'steadfast'],
            antonyms: ['yielding', 'weak', 'flexible'],
            pronunciation: 'tuh-NAY-shuhs',
            partOfSpeech: 'adjective',
            usageNotes: 'Used to describe people with strong resolve',
          ),
        ),
        Word(
          id: '8',
          word: 'ambiguous',
          translation: 'غامض',
          definition: 'open to more than one interpretation; not clear',
          dateAdded: DateTime.now().subtract(Duration(days: 32)),
          examples: [
            'The ending of the story was ambiguous.',
            'Her response was deliberately ambiguous.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['uncertainty', 'vague', 'language'],
          masteryScore: 55.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['unclear', 'vague', 'obscure'],
            antonyms: ['clear', 'definite', 'certain'],
            pronunciation: 'am-BIG-yoo-us',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '9',
          word: 'innate',
          translation: 'فطري',
          definition: 'inborn; natural',
          dateAdded: DateTime.now().subtract(Duration(days: 30)),
          examples: [
            'He has an innate ability to connect with people.',
            'Some talents are considered innate rather than learned.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['natural', 'inborn', 'traits'],
          masteryScore: 75.0,
          reviewStatus: ReviewStatus.mastered,
          details: WordDetails(
            synonyms: ['inherent', 'natural', 'instinctive'],
            antonyms: ['acquired', 'learned', 'artificial'],
            pronunciation: 'in-NATE',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '10',
          word: 'cognizant',
          translation: 'مدرك',
          definition: 'having knowledge or awareness',
          dateAdded: DateTime.now().subtract(Duration(days: 28)),
          examples: [
            'They are cognizant of the potential risks.',
            'She became cognizant of the changes around her.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['awareness', 'knowledge', 'formal'],
          masteryScore: 50.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['aware', 'informed', 'conscious'],
            antonyms: ['unaware', 'ignorant', 'oblivious'],
            pronunciation: 'KOG-ni-zuhnt',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '11',
          word: 'pragmatic',
          translation: 'واقعي',
          definition: 'dealing with things sensibly and realistically',
          dateAdded: DateTime.now().subtract(Duration(days: 26)),
          examples: [
            'She took a pragmatic approach to solving the problem.',
            'Pragmatic solutions often work better in the real world.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['practical', 'realistic', 'sensible'],
          masteryScore: 65.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['practical', 'realistic', 'sensible'],
            antonyms: ['idealistic', 'theoretical', 'impractical'],
            pronunciation: 'prag-MAT-ik',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '12',
          word: 'lucid',
          translation: 'واضح',
          definition: 'clear and easy to understand',
          dateAdded: DateTime.now().subtract(Duration(days: 24)),
          examples: [
            'His explanations are always lucid and precise.',
            'The dream was surprisingly lucid.'
          ],
          difficulty: Difficulty.beginner,
          tags: ['clarity', 'understanding', 'language'],
          masteryScore: 85.0,
          reviewStatus: ReviewStatus.mastered,
          details: WordDetails(
            synonyms: ['clear', 'comprehensible', 'intelligible'],
            antonyms: ['confusing', 'ambiguous', 'vague'],
            pronunciation: 'LOO-sid',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '13',
          word: 'persevere',
          translation: 'يثابر',
          definition: 'to persist in a course of action despite difficulty',
          dateAdded: DateTime.now().subtract(Duration(days: 22)),
          examples: [
            'Despite challenges, she continued to persevere.',
            'They persevered through difficult conditions.'
          ],
          difficulty: Difficulty.beginner,
          tags: ['determination', 'persistence', 'effort'],
          masteryScore: 80.0,
          reviewStatus: ReviewStatus.mastered,
          details: WordDetails(
            synonyms: ['persist', 'endure', 'continue'],
            antonyms: ['give up', 'quit', 'surrender'],
            pronunciation: 'PUR-suh-veer',
            partOfSpeech: 'verb',
          ),
        ),
        Word(
          id: '14',
          word: 'mitigate',
          translation: 'يخفف',
          definition: 'to make less severe or serious',
          dateAdded: DateTime.now().subtract(Duration(days: 18)),
          examples: [
            'Efforts were made to mitigate the damage.',
            'They implemented strategies to mitigate risks.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['reduction', 'alleviation', 'formal'],
          masteryScore: 60.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['reduce', 'alleviate', 'lessen'],
            antonyms: ['intensify', 'worsen', 'aggravate'],
            pronunciation: 'MIT-i-gate',
            partOfSpeech: 'verb',
          ),
        ),
        Word(
          id: '15',
          word: 'euphoria',
          translation: 'نشوة',
          definition: 'a feeling of intense excitement and happiness',
          dateAdded: DateTime.now().subtract(Duration(days: 12)),
          examples: [
            'She felt a surge of euphoria after the accomplishment.',
            'Winning the competition brought him euphoria.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['emotion', 'positive', 'experience'],
          masteryScore: 55.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['joy', 'bliss', 'elation'],
            antonyms: ['despair', 'sadness', 'misery'],
            pronunciation: 'yoo-FOR-ee-uh',
            partOfSpeech: 'noun',
          ),
        ),
      ];

      // Batch write to Firebase
      final batch = _firestore.batch();

      for (var word in testWords) {
        final docRef = _firestore.collection('words').doc();
        batch.set(docRef, word.toFirestore());
      }

      await batch.commit();
      print('Successfully migrated test data to Firebase');
    } catch (e) {
      print('Error migrating test data: $e');
      rethrow;
    }
  }
}
