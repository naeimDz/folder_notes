import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word.dart';

class WordController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'words';

  // Create
  Future<void> addWord(Word word) async {
    try {
      word.validate();
      await _firestore.collection(_collection).doc().set(word.toFirestore());
    } catch (e) {
      throw Exception('Failed to add word: $e');
    }
  }

  // Read
  Future<Word?> getWord(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      return doc.exists ? Word.fromFirestore(doc) : null;
    } catch (e) {
      throw Exception('Failed to get word: $e');
    }
  }

  // Update
  Future<void> updateWord(Word word) async {
    try {
      word.validate();
      await _firestore
          .collection(_collection)
          .doc(word.id)
          .update(word.toFirestore());
    } catch (e) {
      throw Exception('Failed to update word: $e');
    }
  }

  // Update Field
  Future<void> updateField({
    required String documentId,
    required String fieldPath,
    required dynamic value,
    bool isArrayUnion = false,
    bool isArrayRemove = false,
  }) async {
    try {
      dynamic updateValue;
      if (isArrayUnion) {
        updateValue = FieldValue.arrayUnion([value]);
      } else if (isArrayRemove) {
        updateValue = FieldValue.arrayRemove([value]);
      } else {
        updateValue = value;
      }

      await _firestore.collection(_collection).doc(documentId).update({
        fieldPath: updateValue,
      });
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.message}");
      throw Exception("Failed to update field: ${e.message}");
    } catch (e) {
      print("Unknown error: $e");
      throw Exception("An unknown error occurred during the update");
    }
  }

  // Delete
  Future<void> deleteWord(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete word: $e');
    }
  }

  // Custom Queries

// Fetch a random word from the collection
  Future<Word?> getRandomWord() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      if (querySnapshot.docs.isNotEmpty) {
        final randomIndex = Random().nextInt(querySnapshot.docs.length);
        final doc = querySnapshot.docs[randomIndex];
        return Word.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get word: $e');
    }
  }

  Stream<List<Word>> getTodaysWords(int latestLimit) {
    return _firestore
        .collection(_collection)
        .orderBy('dateAdded', descending: true)
        .limit(latestLimit)
        .snapshots()
        .handleError((error) {
      print("Error fetching words: $error");
    }) // Log error, or handle it in any way you need
        .map((snapshot) {
      return snapshot.docs.map((doc) => Word.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Word>> getWords() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Word.fromFirestore(doc)).toList());
  }

  Stream<List<Word>> getWordsByDifficulty(Difficulty difficulty) {
    return _firestore
        .collection(_collection)
        .where('difficulty', isEqualTo: difficulty.toString())
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Word.fromFirestore(doc)).toList());
  }

  Stream<List<Word>> getWordsByCustomProperty(
      String propertyName, dynamic value) {
    return _firestore
        .collection(_collection)
        .where('customProperties.$propertyName.value', isEqualTo: value)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Word.fromFirestore(doc)).toList());
  }

  Stream<List<Word>> getFavoriteWords() {
    return _firestore
        .collection(_collection)
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Word.fromFirestore(doc)).toList());
  }

  Stream<List<Word>> getWordsForReview() {
    final now = DateTime.now();
    return _firestore
        .collection(_collection)
        .where('nextReview', isLessThanOrEqualTo: now)
        .orderBy('nextReview')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Word.fromFirestore(doc)).toList());
  }
}
