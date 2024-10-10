// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cesarpay/domain/controller/ControllerLoan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  String _selectedInterestType = 'Simple';
  final ControllerLoan _controllerLoan = ControllerLoan(FirebaseFirestore.instance);
  String _message = "";

  void _requestLoan() async {
    final document = _documentController.text.trim();
    final loanAmount = double.tryParse(_loanAmountController.text.trim()) ?? 0;

    // Verificar la elegibilidad primero
    final eligibilityMessage = await _controllerLoan.checkEligibility(document);
    
    if (eligibilityMessage.startsWith("Eres apto")) {
      final requestMessage = await _controllerLoan.requestLoan(document, loanAmount, _selectedInterestType);
      setState(() {
        _message = requestMessage;
      });
    } else {
      setState(() {
        _message = eligibilityMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Préstamo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _documentController,
              decoration: const InputDecoration(
                labelText: 'Número de documento',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _loanAmountController,
              decoration: const InputDecoration(
                labelText: 'Valor del préstamo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedInterestType,
              items: [
                'Simple',
                'Compuesto',
                'Gradiente Aritmético',
                'Gradiente Geométrico',
                'Amortización Alemana',
                'Amortización Francesa',
                'Amortización Americana',
              ].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedInterestType = value ?? 'Simple';
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de interés',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestLoan,
              child: const Text('Solicitar Préstamo'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
