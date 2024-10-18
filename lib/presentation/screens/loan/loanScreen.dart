// ignore_for_file: use_build_context_synchronously

import 'package:cesarpay/presentation/screens/loan/PaymentDetailsScreen.dart';
import 'package:cesarpay/providers/amortizacion/amortization_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cesarpay/domain/controller/ControllerLoan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cesarpay/presentation/widget/shared/custom_background.dart';
import 'package:cesarpay/presentation/widget/shared/custom_filled_button.dart';
import 'package:cesarpay/presentation/widget/shared/custom_dropdown_menu.dart';


class LoanScreen extends ConsumerWidget {
  const LoanScreen({super.key});

  void _showMessage(BuildContext context, String message, {bool isSuccess = true}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Éxito' : 'Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _requestLoan(BuildContext context, WidgetRef ref, String document, double loanAmount, int selectedInstallments) async {
    final ControllerLoan controllerLoan = ControllerLoan(FirebaseFirestore.instance);
    String message = "";

    final eligibilityMessage = await controllerLoan.checkEligibility(document);
    if (eligibilityMessage.startsWith("Eres apto")) {
      ref.read(amortizationProvider.notifier).onCapitalChanged(loanAmount);
      ref.read(amortizationProvider.notifier).onInterestRateChanged(5.0);
      ref.read(amortizationProvider.notifier).onPeriodsChanged(selectedInstallments);
      ref.read(amortizationProvider.notifier).onAmortizationTypeChanged(ref.watch(amortizationProvider).amortizationType);

      ref.read(amortizationProvider.notifier).calculateAmortization();

      // Imprime los pagos calculados para verificar el formato
      final payments = ref.read(amortizationProvider).payments;

      await controllerLoan.requestLoan(document, loanAmount, ref.watch(amortizationProvider).amortizationType, payments);
      await _storePaymentsInFirestore(document, payments);
      
      // Mostrar alerta de éxito
      _showMessage(context, 'Préstamo solicitado con éxito. Las cuotas han sido calculadas y almacenadas.', isSuccess: true);
      
      // Navegar a la pantalla de detalles de pagos
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaymentDetailsScreen(payments: payments, document: document),
      ));

    } else {
      message = eligibilityMessage;

      // Mostrar alerta de error
      _showMessage(context, message, isSuccess: false);
    }
  }

Future<void> _storePaymentsInFirestore(String document, List<Map<String, double>> payments) async {
  final collectionRef = FirebaseFirestore.instance.collection('loan_payments');

  // Crea o actualiza un único documento con el número de documento del usuario
  await collectionRef.doc(document).set({
    'document': document,
    'payments': payments.map((payment) => {
      'cuota': payment['cuota']?.toStringAsFixed(2) ?? '0.00',
      'interes': payment['interes']?.toStringAsFixed(2) ?? '0.00',
      'amortizacion': payment['amortizacion']?.toStringAsFixed(2) ?? '0.00',
    }).toList(),
  }, SetOptions(merge: true));
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentController = TextEditingController();
    final loanAmountController = TextEditingController();
    final amortizationState = ref.watch(amortizationProvider);
    final installmentsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Préstamo')),
      body: CustomBackground(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Solicitar Préstamo", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 0, 140, 255),
                  thickness: 5,
                  indent: 50,
                  endIndent: 50,
                ),
                const SizedBox(height: 16),
                // Mensaje de selección
                const SizedBox(height: 20),
                const Text("Selecciona el tipo de amortización:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                
                // Menú desplegable para tipo de amortización
                CustomDropDownMenu(
                  hintText: "Seleccionar",
                  options: const {'Francesa': 'Francesa', 'Alemana': 'Alemana', 'Americana': 'Americana'},
                  onSelected: (value) {
                    ref.read(amortizationProvider.notifier).onAmortizationTypeChanged(value!);
                  },
                  errorText: amortizationState.isFormPosted && amortizationState.amortizationType.isEmpty
                      ? "Seleccione un tipo de amortización"
                      : null,
                ),
                const SizedBox(height: 20),
                // Campo para número de documento
                TextField(
                  controller: documentController,
                  decoration: const InputDecoration(
                    labelText: 'Número de documento',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                // Campo para valor del préstamo
                TextField(
                  controller: loanAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Valor del préstamo',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                
                const SizedBox(height: 16),
                TextField(
                  controller: installmentsController, // Campo para número de cuotas
                  decoration: const InputDecoration(
                    labelText: 'Número de cuotas',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                // Botón para solicitar préstamo
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: CustomFilledButton(
                    onPressed: () {
                      final document = documentController.text.trim();
                      final loanAmount = double.tryParse(loanAmountController.text.trim()) ?? 0;
                      final selectedInstallments = int.tryParse(installmentsController.text.trim()) ?? 0;
                      _requestLoan(context, ref, document, loanAmount, selectedInstallments); // Agrega 'context' aquí
                    },
                    buttonColor: const Color.fromARGB(255, 0, 140, 255),
                    child: const Text('Solicitar Préstamo'),
                  ),
                ),
                const SizedBox(height: 20),
                // Ya no se muestra el listado de pagos aquí
              ],
            ),
          ),
        ),
      ),
    );
  }
}
