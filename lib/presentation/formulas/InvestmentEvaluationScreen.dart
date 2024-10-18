import 'package:cesarpay/presentation/widget/shared/custom_filled_button.dart';
import 'package:cesarpay/presentation/widget/shared/custom_text_form_field.dart';
import 'package:cesarpay/providers/alternative_inversion/InvestmentEvaluationFormState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class InvestmentEvaluationScreen extends ConsumerWidget {
  const InvestmentEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investmentForm = ref.watch(investmentEvaluationFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación de Alternativas de Inversión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inversión Inicial'),
              CustomTextFormField(
                label: 'Inversión Inicial',
                onChanged: (value) {
                  ref
                      .read(investmentEvaluationFormProvider.notifier)
                      .onInitialInvestmentChanged(double.tryParse(value) ?? 0);
                },
              ),
              const SizedBox(height: 20),
              const Text('Flujos de Caja'),
              CustomTextFormField(
                label: 'Flujos de Caja (separados por comas)',
                onChanged: (value) {
                  List<double> cashFlows = value
                      .split(',')
                      .map((e) => double.tryParse(e.trim()) ?? 0)
                      .toList();
                  ref
                      .read(investmentEvaluationFormProvider.notifier)
                      .onCashFlowsChanged(cashFlows);
                },
              ),
              const SizedBox(height: 20),
              const Text('Tasa de Descuento (%)'),
              CustomTextFormField(
                label: 'Tasa de Descuento',
                onChanged: (value) {
                  ref
                      .read(investmentEvaluationFormProvider.notifier)
                      .onDiscountRateChanged(double.tryParse(value) ?? 0);
                },
              ),
              const SizedBox(height: 30),
              CustomFilledButton(
                onPressed: ref
                    .read(investmentEvaluationFormProvider.notifier)
                    .calculateNPV,
                child: const Text('Calcular VPN'),
              ),
              const SizedBox(height: 30),
              if (investmentForm.isFormPosted)
                Text('Resultado VPN: ${investmentForm.result.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }
}
