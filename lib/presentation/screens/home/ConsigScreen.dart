// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsignarScreen extends StatefulWidget {
  const ConsignarScreen({super.key});

  @override
  _ConsignarScreenState createState() => _ConsignarScreenState();
}

class _ConsignarScreenState extends State<ConsignarScreen> {
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  bool _isLoading = false; // Estado de carga

  Future<void> _consignar() async {
    String documento = documentoController.text;
    String monto = montoController.text;

    // Validar campos
    if (documento.isEmpty || monto.isEmpty) {
      _showError('Por favor, complete todos los campos.');
      return;
    }

    setState(() {
      _isLoading = true; // Activar indicador de carga
    });

    try {
      // Buscar el usuario en Firebase
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users') // Cambia 'users' al nombre de tu colección
          .where('document', isEqualTo: documento)
          .limit(1) // Limitar a un solo resultado
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first; // Devuelve el primer documento encontrado
            }
            throw Exception('Usuario no encontrado.');
          });

      // Obtener el balance actual y sumarle el monto
      double currentBalance = userSnapshot['balance'] as double? ?? 0.0;
      double newBalance = currentBalance + double.parse(monto);

      // Actualizar el balance en Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userSnapshot.id) // Usar el ID del documento encontrado
          .update({'balance': newBalance});

      // Mostrar mensaje de éxito
      _showSuccess('Consignación exitosa! Nuevo balance: \$${newBalance.toStringAsFixed(2)}');
    } catch (e) {
      _showError('Error al realizar la consignación: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false; // Desactivar indicador de carga
      });
    }
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éxito'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              documentoController.clear();
              montoController.clear();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consignar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Formulario de Consignación',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: documentoController,
              decoration: const InputDecoration(
                labelText: 'Número de Documento',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: montoController,
              decoration: const InputDecoration(
                labelText: 'Monto a Consignar',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            _isLoading // Mostrar indicador de carga si es necesario
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _consignar,
                    child: const Text('Consignar'),
                  ),
          ],
        ),
      ),
    );
  }
}
