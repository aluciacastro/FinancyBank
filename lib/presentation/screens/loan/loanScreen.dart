// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unused_local_variable, no_leading_underscores_for_local_identifiers

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

  void _requestLoan(WidgetRef ref, String document, double loanAmount, String selectedInterestType, int selectedInstallments) async {
  final ControllerLoan controllerLoan = ControllerLoan(FirebaseFirestore.instance);
  String _message = "";

  final eligibilityMessage = await controllerLoan.checkEligibility(document);
  if (eligibilityMessage.startsWith("Eres apto")) {
    ref.read(amortizationProvider.notifier).onCapitalChanged(loanAmount);
    ref.read(amortizationProvider.notifier).onInterestRateChanged(5.0);
    ref.read(amortizationProvider.notifier).onPeriodsChanged(selectedInstallments);
    ref.read(amortizationProvider.notifier).onAmortizationTypeChanged(selectedInterestType);

    ref.read(amortizationProvider.notifier).calculateAmortization();
    
    // Imprime los pagos calculados para verificar el formato
    final payments = ref.read(amortizationProvider).payments;
  
    
    await controllerLoan.requestLoan(document, loanAmount, selectedInterestType, payments);
    await _storePaymentsInFirestore(document, payments);
    
    ref.read(amortizationProvider.notifier).state = ref.read(amortizationProvider).copyWith(isFormPosted: true, message: 'Préstamo solicitado con éxito. Las cuotas han sido calculadas y almacenadas.');
  } else {
    _message = eligibilityMessage;
    ref.read(amortizationProvider.notifier).state = ref.read(amortizationProvider).copyWith(isFormPosted: false, message: _message);
  }
}


  Future<void> _storePaymentsInFirestore(String document, List<Map<String, double>> payments) async {
  final collectionRef = FirebaseFirestore.instance.collection('loan_payments');
  
  for (int i = 0; i < payments.length; i++) {
    var payment = payments[i];
    
     
    await collectionRef.add({
      'document': document,
      'Pago': i + 1,
      'Cuota': payment['cuota']?.toStringAsFixed(2) ?? '0.00',
      'Interés': payment['interes']?.toStringAsFixed(2) ?? '0.00',
      'Amortización': payment['amortizacion']?.toStringAsFixed(2) ?? '0.00',
    });
  }
}



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentController = TextEditingController();
    final loanAmountController = TextEditingController();
    final amortizationState = ref.watch(amortizationProvider);
    String selectedInterestType = amortizationState.amortizationType; 
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
                      _requestLoan(ref, document, loanAmount, amortizationState.amortizationType, selectedInstallments);
                    },
                    buttonColor: const Color.fromARGB(255, 0, 140, 255),
                    child: const Text('Solicitar Préstamo'),
                  ),
                ),
                const SizedBox(height: 20),
                // Mensaje de respuesta
                Text(
                  amortizationState.message,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Listado de pagos calculados
                if (amortizationState.payments.isNotEmpty) ...[
                  const Text(
                    "Detalles de los pagos:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 200, // Ajusta esta altura según la necesidad
                    child: ListView.builder(
                      shrinkWrap: true, // Permite que el ListView funcione correctamente en Column
                      itemCount: amortizationState.payments.length,
                      itemBuilder: (context, index) {
                        final payment = amortizationState.payments[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pago ${index + 1}:",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Usamos toStringAsFixed(2) para mostrar 2 decimales
                            Text("Cuota: ${payment['cuota']!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black)),
                            Text("Interés: ${payment['interes']!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black)),
                            Text("Amortización: ${payment['amortizacion']!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black)),
                            const SizedBox(height: 6),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
