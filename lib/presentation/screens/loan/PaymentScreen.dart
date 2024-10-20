// Ignorar el archivo para evitar advertencias.
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cesarpay/domain/controller/ControllerPayment.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String document; // Este es el documento del usuario que se pasa al controlador

  const PaymentScreen({super.key, required this.document});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentController _paymentController;
  late Future<List<Map<String, dynamic>>> _payments;
  bool _isProcessingPayment = false; // Variable para manejar el estado de procesamiento

  @override
  void initState() {
    super.initState();
    _paymentController = PaymentController(document: widget.document);
    _payments = _paymentController.getPayments(widget.document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pagos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _payments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay pagos disponibles'));
          } else {
            final payments = snapshot.data!;

            return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];

                // Convertir 'cuota' de cadena a número
                final amount = double.tryParse(payment['cuota']?.toString() ?? '0') ?? 0.0; 
                final status = payment['estado'] ?? false; // Asegúrate de que el estado se llame 'estado'

                return Card(
                  color: const Color.fromARGB(255, 0, 140, 255), // Color de la tarjeta
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0), // Espaciado dentro de la tarjeta
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinear contenido en ambos lados
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pago: \$${amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white, // Color del texto
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10), // Espaciado entre el monto y el estado
                              Text(
                                'Estado: ${status ? 'Pagado' : 'Pendiente'}',
                                style: const TextStyle(
                                  color: Colors.white, // Color del texto
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10), // Espaciado entre la columna y el botón
                        ElevatedButton(
                          onPressed: status || _isProcessingPayment ? null : () async {
                            setState(() {
                              _isProcessingPayment = true; // Establecer estado de procesamiento
                            });

                            // Lógica para realizar el pago
                            bool success = await _paymentController.processPayment(payment);
                            if (success) {
                              setState(() {
                                _payments = _paymentController.getPayments(widget.document); // Recargar los pagos
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pago procesado con éxito')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al procesar el pago')),
                              );
                            }

                            setState(() {
                              _isProcessingPayment = false; // Restablecer estado de procesamiento
                            });
                          },
                          child: _isProcessingPayment 
                              ? const CircularProgressIndicator() 
                              : const Text('Pagar'), // Mostrar indicador de carga
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
