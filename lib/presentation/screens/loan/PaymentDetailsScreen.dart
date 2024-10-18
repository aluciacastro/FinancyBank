import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final List<Map<String, double>> payments;

  const PaymentDetailsScreen({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de Pagos')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];
            return Card(
              color: const Color.fromARGB(255, 0, 140, 255), // Color azul especificado
              elevation: 4, // Sombra para darle un efecto de elevación
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              margin: const EdgeInsets.symmetric(vertical: 10), // Espacio vertical entre tarjetas
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Espaciado interno de la tarjeta
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pago ${index + 1}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Color de texto blanco
                      ),
                    ),
                    const SizedBox(height: 8), // Espacio entre el título y la información
                    Text("Cuota: ${payment['cuota']?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                    Text("Interés: ${payment['interes']?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                    Text("Amortización: ${payment['amortizacion']?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
