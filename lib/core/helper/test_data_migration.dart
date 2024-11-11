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
          translation: '遍在的',
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
          translation: '短暫的',
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
          translation: '意外發現',
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
          translation: '範例',
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
          translation: '有彈性的',
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
