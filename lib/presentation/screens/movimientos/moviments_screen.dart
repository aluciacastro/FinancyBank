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

  @override
  void initState() {
    super.initState();
    _movementService = MovementService();
    _withdrawalHistory = _movementService.getRetiroHistorial(widget.document);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFEFEFEF), // Color de fondo si es necesario
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _withdrawalHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los movimientos'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay retiros disponibles'));
            } else {
              final withdrawals = snapshot.data!;
              return ListView.builder(
                itemCount: withdrawals.length,
                itemBuilder: (context, index) {
                  final withdrawal = withdrawals[index];
                  final description = withdrawal['descripcion'] ?? 'Descripción no disponible';
                  final date = withdrawal['fecha'] ?? DateTime.now();
                  final amount = withdrawal['monto'] ?? 0.0;

                  return Card(
                    color: const Color.fromARGB(255, 0, 140, 255),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Retiro: \$${amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Descripción: $description',
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Fecha: ${date.toLocal()}',
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
