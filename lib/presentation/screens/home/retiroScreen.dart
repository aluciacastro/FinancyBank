// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cesarpay/presentation/widget/Waves.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cesarpay/domain/controller/ControlerRetiro.dart';
import 'package:cesarpay/presentation/screens/home/ReciboRetiroScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RetiroScreen extends StatefulWidget {
  const RetiroScreen({super.key});

  @override
  _RetiroScreenState createState() => _RetiroScreenState();
}

class _RetiroScreenState extends State<RetiroScreen> {
  final TextEditingController _montoController = TextEditingController();
  bool _isLoading = false;
  late String _documentId;
  late String _nombreUsuario;

  final ControllerRetiro _controllerRetiro = ControllerRetiro(); // Instancia del controlador

  @override
  void initState() {
    super.initState();
    _getUserDocument();
  }

  // Obtener el documento almacenado en SharedPreferences
  Future<void> _getUserDocument() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? documentId = prefs.getString('lastUserDocument');
    if (documentId != null) {
      setState(() {
        _documentId = documentId;
      });
      _obtenerNombreUsuario(documentId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Documento de usuario no encontrado en la caché')),
      );
      Navigator.pop(context);
    }
  }

  // Método para obtener el nombre del usuario utilizando el controlador
  Future<void> _obtenerNombreUsuario(String documentId) async {
    String nombreUsuario = await _controllerRetiro.obtenerNombreUsuario(documentId);
    setState(() {
      _nombreUsuario = nombreUsuario;
    });
  }

  Future<void> _realizarRetiro() async {
    if (_montoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un monto válido')),
      );
      return;
    }

    double monto = double.parse(_montoController.text);
    setState(() {
      _isLoading = true;
    });

    try {
      String result = await _controllerRetiro.retirar(monto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );

      if (result.contains('Retiro exitoso')) {
        // Realizar la transacción inmediatamente
        await _realizarTransaccion(monto);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar el retiro: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _realizarTransaccion(double monto) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('document', isEqualTo: _documentId)
          .limit(1)
          .get();

      if (userDocs.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = userDocs.docs.first;
        double balanceActual = userDoc.data()?['balance'] ?? 0.0;

        if (monto > balanceActual) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El monto excede el balance disponible')),
          );
        } else {
          double nuevoSaldo = balanceActual - monto;
          await FirebaseFirestore.instance.collection('users').doc(userDoc.id).update({
            'balance': nuevoSaldo,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReciboRetiroScreen(
                montoRetirado: monto,
                nuevoSaldo: nuevoSaldo,
                nombreUsuario: _nombreUsuario,
                fechaRetiro: DateTime.now(),
                documento: _documentId, // Agregado
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el usuario en la base de datos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la transacción: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retiro'),
      ),
      body: Stack(
        children: [
          const WaveBackground(), 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  const SizedBox(height: 100),
                  Lottie.asset(
                    'assets/lottie/Retiro_Animation.json', 
                    width: 170, 
                    height: 170,
                    fit: BoxFit.fill,
                  ),
                  const Text(
                    'Monto a retirar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _montoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa el monto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _realizarRetiro,
                          child: const Text('Retirar'),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
