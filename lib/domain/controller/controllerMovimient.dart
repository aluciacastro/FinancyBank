import 'package:cloud_firestore/cloud_firestore.dart';

class MovementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMovement({
    required String userId, 
    required String calculationType, 
    required double result,
  }) async {
    try {
      final collectionRef = _firestore.collection('movements');
      await collectionRef.add({
        'userId': userId,
        'calculationType': calculationType,
        'result': result,
        'date': Timestamp.now(),
      });
      
    } catch (e) {
      // ignore: avoid_print
      print("Error al guardar el movimiento: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getMovements(String userId) {
    return _firestore
        .collection('movements')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
