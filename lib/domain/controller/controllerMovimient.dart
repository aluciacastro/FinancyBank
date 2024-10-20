import 'package:cloud_firestore/cloud_firestore.dart';

class MovementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener el historial de retiros de la colección 'retiros_historial'
  Stream<List<Map<String, dynamic>>> getRetiroHistorial(String documentId) {
    return _firestore
        .collection('retiros_historial') 
        .where('document', isEqualTo: documentId) 
        .orderBy('movimiento.fecha', descending: true) 
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();

              // Verificamos que los campos necesarios existan antes de acceder a ellos
              final movimiento = data['movimiento'] as Map<String, dynamic>? ?? {};
              final descripcion = movimiento['descripcion'] ?? 'Descripción no disponible';
              final fecha = movimiento['fecha'] != null
                  ? (movimiento['fecha'] as Timestamp).toDate()
                  : DateTime.now(); // Si no hay fecha, asignamos la fecha actual
              final monto = movimiento['monto'] ?? 0.0;
              print("Received ${snapshot.docs.length} documents.");

              return {
                'descripcion': descripcion,
                'fecha': fecha,
                'monto': monto,
              };
            }).toList());
  }
}
