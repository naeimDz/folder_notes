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
          translation: 'منتشر في كل مكان',
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
          translation: 'صدفة سعيدة',
          definition: 'finding something good without looking for it',
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
          definition: 'able to recover quickly from difficulties',
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
          word: 'eloquent',
          translation: 'بليغ',
          definition: 'fluent or persuasive in speaking or writing',
          dateAdded: DateTime.now().subtract(Duration(days: 8)),
          examples: [
            'She gave an eloquent speech at the conference.',
            'His eloquent writing style captivated readers.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['communication', 'language', 'speaking'],
          masteryScore: 70.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['articulate', 'fluent', 'persuasive'],
            antonyms: ['inarticulate', 'awkward', 'unclear'],
            pronunciation: 'EL-oh-kwent',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '7',
          word: 'authentic',
          translation: 'أصيل',
          definition: 'genuine or original, not fake',
          dateAdded: DateTime.now().subtract(Duration(days: 6)),
          examples: [
            'The restaurant serves authentic Italian cuisine.',
            'She values authentic friendships over superficial ones.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['quality', 'genuine', 'real'],
          masteryScore: 55.0,
          reviewStatus: ReviewStatus.reviewing,
          details: WordDetails(
            synonyms: ['genuine', 'real', 'legitimate'],
            antonyms: ['fake', 'artificial', 'counterfeit'],
            pronunciation: 'aw-THEN-tik',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '8',
          word: 'meticulous',
          translation: 'دقيق جداً',
          definition: 'showing great attention to detail',
          dateAdded: DateTime.now().subtract(Duration(days: 5)),
          examples: [
            'He is meticulous in his research methodology.',
            'The artists meticulous attention to detail was evident.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['behavior', 'work', 'quality'],
          masteryScore: 40.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['thorough', 'precise', 'careful'],
            antonyms: ['careless', 'sloppy', 'negligent'],
            pronunciation: 'muh-TIK-yoo-lus',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '9',
          word: 'ambiguous',
          translation: 'غامض',
          definition: 'open to more than one interpretation',
          dateAdded: DateTime.now().subtract(Duration(days: 4)),
          examples: [
            'The contract contained several ambiguous clauses.',
            'His response was ambiguous and unclear.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['language', 'meaning', 'clarity'],
          masteryScore: 25.0,
          reviewStatus: ReviewStatus.newAdded,
          details: WordDetails(
            synonyms: ['unclear', 'vague', 'equivocal'],
            antonyms: ['clear', 'obvious', 'unambiguous'],
            pronunciation: 'am-BIG-yoo-us',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '10',
          word: 'pragmatic',
          translation: 'عملي',
          definition: 'dealing with things sensibly and realistically',
          dateAdded: DateTime.now().subtract(Duration(days: 3)),
          examples: [
            'We need a pragmatic approach to solve this problem.',
            'Shes known for her pragmatic decision-making style.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['behavior', 'thinking', 'practical'],
          masteryScore: 60.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['practical', 'realistic', 'sensible'],
            antonyms: ['idealistic', 'unrealistic', 'impractical'],
            pronunciation: 'prag-MAT-ik',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '11',
          word: 'diligent',
          translation: 'مجتهد',
          definition: 'having or showing care and conscientiousness',
          dateAdded: DateTime.now().subtract(Duration(days: 2)),
          examples: [
            'She is a diligent student who always completes her assignments.',
            'His diligent work ethic impressed his supervisors.'
          ],
          difficulty: Difficulty.beginner,
          tags: ['work', 'character', 'behavior'],
          masteryScore: 75.0,
          reviewStatus: ReviewStatus.reviewing,
          details: WordDetails(
            synonyms: ['hardworking', 'conscientious', 'industrious'],
            antonyms: ['lazy', 'negligent', 'careless'],
            pronunciation: 'DIL-i-jent',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '12',
          word: 'empathy',
          translation: 'تعاطف',
          definition: 'ability to understand and share feelings of others',
          dateAdded: DateTime.now().subtract(Duration(days: 1)),
          examples: [
            'Good leaders show empathy towards their team members.',
            'Doctors need to have empathy for their patients.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['emotions', 'psychology', 'relationships'],
          masteryScore: 85.0,
          reviewStatus: ReviewStatus.mastered,
          details: WordDetails(
            synonyms: ['understanding', 'compassion', 'sensitivity'],
            antonyms: ['indifference', 'apathy', 'coldness'],
            pronunciation: 'EM-puh-thee',
            partOfSpeech: 'noun',
          ),
        ),
        Word(
          id: '13',
          word: 'innovative',
          translation: 'مبتكر',
          definition: 'featuring new methods; advanced and original',
          dateAdded: DateTime.now().subtract(Duration(days: 1)),
          examples: [
            'The company developed an innovative solution.',
            'Her innovative teaching methods engaged all students.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['business', 'technology', 'creativity'],
          masteryScore: 50.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['creative', 'original', 'groundbreaking'],
            antonyms: ['conventional', 'traditional', 'old-fashioned'],
            pronunciation: 'IN-oh-vay-tiv',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '14',
          word: 'profound',
          translation: 'عميق',
          definition:
              'very great or intense; showing great knowledge or insight',
          dateAdded: DateTime.now(),
          examples: [
            'The book had a profound impact on her life.',
            'He made some profound observations about human nature.'
          ],
          difficulty: Difficulty.advanced,
          tags: ['philosophy', 'thinking', 'impact'],
          masteryScore: 35.0,
          reviewStatus: ReviewStatus.newAdded,
          details: WordDetails(
            synonyms: ['deep', 'intense', 'thoughtful'],
            antonyms: ['shallow', 'superficial', 'slight'],
            pronunciation: 'pro-FOUND',
            partOfSpeech: 'adjective',
          ),
        ),
        Word(
          id: '15',
          word: 'versatile',
          translation: 'متعدد المواهب',
          definition:
              'able to adapt or be adapted to many different functions or activities',
          dateAdded: DateTime.now(),
          examples: [
            'A smartphone is a versatile device.',
            'She is a versatile actress who can play many different roles.'
          ],
          difficulty: Difficulty.intermediate,
          tags: ['ability', 'flexibility', 'skill'],
          masteryScore: 45.0,
          reviewStatus: ReviewStatus.learning,
          details: WordDetails(
            synonyms: ['adaptable', 'flexible', 'all-round'],
            antonyms: ['inflexible', 'limited', 'rigid'],
            pronunciation: 'VER-suh-til',
            partOfSpeech: 'adjective',
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
