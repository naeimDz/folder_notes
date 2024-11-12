import 'package:cloud_firestore/cloud_firestore.dart';

class MetadataController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'metadata';

  Future<int> getWordsCount() async {
    try {
      // Get the reference to the metadata document
      DocumentReference metadataRef =
          _firestore.collection(_collection).doc('words_count');

      // Get the document snapshot
      DocumentSnapshot snapshot = await metadataRef.get();

      if (snapshot.exists) {
        return snapshot['count'];
      } else {
        return 0; // Return 0 if no count document exists
      }
    } catch (e) {
      print('Error getting document count: $e');
      return 0;
    }
  }

//Function to update the count of the 'words' collection in the metadata document

  Future<int> updateDocumentCount({bool decrement = false}) async {
    try {
      // Get the reference to the metadata document
      DocumentReference metadataRef =
          _firestore.collection(_collection).doc('words_count');
      DocumentSnapshot snapshot = await metadataRef.get();
      int currentCount = snapshot.exists ? snapshot['count'] : 0;

      // Increment or decrement the count
      int newCount = decrement ? currentCount - 1 : currentCount + 1;
      await metadataRef.set({'count': newCount});
      return newCount;
    } catch (e) {
      print('Error updating document count: $e');
      return 0;
    }
  }
}
