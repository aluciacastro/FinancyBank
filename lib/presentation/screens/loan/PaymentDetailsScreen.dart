import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final List<Map<String, double>> payments;
  final String document;

  const PaymentDetailsScreen({super.key, required this.payments, required this.document});

  Future<List<Map<String, dynamic>>> _getPayments(String document) async {
  final docSnapshot = await FirebaseFirestore.instance.collection('loan_payments').doc(document).get();
  final data = docSnapshot.data();
  
  if (data != null && data['payments'] != null) {
    final payments = data['payments'] as List<dynamic>;
    return payments.map<Map<String, dynamic>>((payment) => {
      'cuota': payment['cuota'] ?? 0.0,
      'interes': payment['interes'] ?? 0.0,
      'amortizacion': payment['amortizacion'] ?? 0.0,
      'estado': payment['estado'] ?? false,
    }).toList();
  }
  
  return []; // Retorna una lista vacía si no hay datos
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de Pagos')),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: _getPayments(document),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los pagos'));
          }

          final payments = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), 
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];

                // Asegúrate de convertir a número antes de usar toStringAsFixed
                double cuota = double.tryParse(payment['cuota'].toString()) ?? 0.0;
                double interes = double.tryParse(payment['interes'].toString()) ?? 0.0;
                double amortizacion = double.tryParse(payment['amortizacion'].toString()) ?? 0.0;

                return Card(
                  color: const Color.fromARGB(255, 0, 140, 255),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10), // Ajusta el espacio vertical
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago ${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Cuota: ${cuota.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                        Text("Interés: ${interes.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                        Text("Amortización: ${amortizacion.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                        Text("Estado: ${payment['estado'] ? 'Pagado' : 'Pendiente'}", style: const TextStyle(fontSize: 16, color: Colors.white)), // Muestra el estado
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
