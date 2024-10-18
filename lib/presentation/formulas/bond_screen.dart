import 'package:cesarpay/providers/bono/BondFormProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/custom_filled_button.dart';

class BondScreen extends ConsumerWidget {
  const BondScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bondForm = ref.watch(bondFormProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Evaluación de Bonos')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextFormField(
              label: 'Valor nominal (Face Value)',
              onChanged: (value) => ref
                  .read(bondFormProvider.notifier)
                  .onFaceValueChanged(double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: 'Tasa de cupón (%)',
              onChanged: (value) => ref
                  .read(bondFormProvider.notifier)
                  .onCouponRateChanged(double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: 'Años hasta vencimiento',
              onChanged: (value) => ref
                  .read(bondFormProvider.notifier)
                  .onYearsToMaturityChanged(int.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: 'Tasa de mercado (%)',
              onChanged: (value) => ref
                  .read(bondFormProvider.notifier)
                  .onMarketRateChanged(double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 30),
            CustomFilledButton(
              onPressed: ref.read(bondFormProvider.notifier).calculate,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 20),
            if (bondForm.isFormPosted)
              Text('El valor del bono es: \$${bondForm.result.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
