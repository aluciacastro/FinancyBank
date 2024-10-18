// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:cesarpay/domain/controller/ControllerConsign.dart';
import 'package:cesarpay/presentation/widget/shared/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class ConsignarScreen extends StatefulWidget {
  const ConsignarScreen({super.key});

  @override
  _ConsignarScreenState createState() => _ConsignarScreenState();
}

class _ConsignarScreenState extends State<ConsignarScreen> {
  final TextEditingController documentoDestinatarioController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final ControllerConsign _controllerConsign = ControllerConsign(); // Instancia de tu controlador
  bool _isLoading = false;

  Future<void> _consignar() async {
    String destinatarioDoc = documentoDestinatarioController.text;
    String monto = montoController.text;

    // Obtener el documento del consignante desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? consignanteDoc = prefs.getString('lastUserDocument');

    if (consignanteDoc == null || consignanteDoc.isEmpty) {
      _showAlert('Error', 'No se ha podido obtener el documento del consignante.');
      return;
    }

    // Verificar si el usuario intenta consignarse a sí mismo
    if (destinatarioDoc == consignanteDoc) {
      _showAlert('Error', 'No puedes consignarte a ti mismo.');
      return;
    }

    if (destinatarioDoc.isEmpty || monto.isEmpty) {
      _showAlert('Error', 'Por favor, complete todos los campos.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Realizar consignación
      String resultado = await _controllerConsign.consignar(
        consignanteDoc,
        destinatarioDoc,
        double.parse(monto),
      );
      print('Resultado de la consignación: $resultado');

      // Mostrar alerta con el resultado
      _showAlert('Alerta', resultado.contains('exitoso') ? resultado : 'Error: $resultado');
    } catch (e) {
      _showAlert('Error', 'Error al realizar la consignación: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              documentoDestinatarioController.clear();
              montoController.clear();
            },
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
      body: Stack(
        children: [
          // WaveBackground Widget
          const WaveBackground(),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centra los elementos en el eje horizontal
              mainAxisAlignment: MainAxisAlignment.start, // Mantiene el orden vertical
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Lottie.asset(
                    'assets/lottie/Consign_Animation.json',
                    width: 170,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                //const SizedBox(height: 20),
                const Text(
                  'Rellene todos los campos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Centra el texto
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: documentoDestinatarioController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Documento Destinatario',
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _consignar,
                        child: const Text('Consignar'),
                      ),
                const SizedBox(height: 20), // Añadir separación después del botón
              ],
            ),
          ),
        ],
      ),
    );
  }
}
