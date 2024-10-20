import 'package:cesarpay/domain/controller/controllerMovimient.dart';
import 'package:flutter/material.dart';

class WithdrawalScreen extends StatefulWidget {
  final String document; // Este es el documento del usuario que se pasa al controlador

  const WithdrawalScreen({super.key, required this.document});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late final MovementService _movementService;
  late Stream<List<Map<String, dynamic>>> _withdrawalHistory; 
  bool _isProcessingWithdrawal = false; 

  @override
  void initState() {
    super.initState();
    _movementService = MovementService();
    _withdrawalHistory = _movementService.getRetiroHistorial(widget.document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Retiros'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _withdrawalHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay retiros disponibles'));
          } else {
            final withdrawals = snapshot.data!;

            return ListView.builder(
              itemCount: withdrawals.length,
              itemBuilder: (context, index) {
                final withdrawal = withdrawals[index];

                // Obtener detalles del retiro
                final description = withdrawal['descripcion'] ?? 'Descripción no disponible';
                final date = withdrawal['fecha'] ?? DateTime.now(); // Asignar fecha actual si no hay fecha
                final amount = withdrawal['monto'] ?? 0.0;

                return Card(
                  color: const Color.fromARGB(255, 255, 0, 140), // Color de la tarjeta
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
                                'Retiro: \$${amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.black, // Color del texto
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10), // Espaciado entre el monto y la descripción
                              Text(
                                'Descripción: $description',
                                style: const TextStyle(
                                  color: Colors.black, // Color del texto
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10), // Espaciado entre la descripción y la fecha
                              Text(
                                'Fecha: ${date.toLocal()}',
                                style: const TextStyle(
                                  color: Colors.black, // Color del texto
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10), // Espaciado entre la columna y el botón
                        ElevatedButton(
                          onPressed: _isProcessingWithdrawal ? null : () async {
                            setState(() {
                              _isProcessingWithdrawal = true; // Establecer estado de procesamiento
                            });

                            // Lógica para realizar alguna acción con el retiro, si es necesario
                            // Por ejemplo, confirmar el retiro
                            // bool success = await _movementService.confirmWithdrawal(withdrawal);
                            // if (success) {
                            //   // Aquí podrías actualizar el historial si fuera necesario
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Retiro confirmado con éxito')),
                            //   );
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Error al confirmar el retiro')),
                            //   );
                            // }

                            setState(() {
                              _isProcessingWithdrawal = false; // Restablecer estado de procesamiento
                            });
                          },
                          child: _isProcessingWithdrawal 
                              ? const CircularProgressIndicator() 
                              : const Text('Confirmar'), // Mostrar indicador de carga
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
