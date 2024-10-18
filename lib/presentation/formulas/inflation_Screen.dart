
import 'package:cesarpay/presentation/widget/shared/custom_background.dart';
import 'package:cesarpay/presentation/widget/shared/custom_filled_button.dart';
import 'package:cesarpay/presentation/widget/shared/custom_text_form_field.dart';
import 'package:cesarpay/presentation/widget/shared/header.dart';
import 'package:cesarpay/providers/inflation/inflationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InflationScreen extends StatelessWidget {
  const InflationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      height: 200,
      showArrow: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 600,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const _InflationForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InflationForm extends ConsumerWidget {
  const _InflationForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inflationForm = ref.watch(inflationFormProvider);

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text("Calculadora de Inflación", style: Theme.of(context).textTheme.titleLarge),
          const Divider(color: Colors.blue, thickness: 5),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: "Precio inicial (P1)",
            onChanged: (value) {
              ref
                  .read(inflationFormProvider.notifier)
                  .onInitialPriceChanged(double.tryParse(value) ?? 0);
            },
            errorMessage: inflationForm.isFormPosted && inflationForm.initialPrice <= 0
                ? "Ingrese un precio inicial válido"
                : null,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: "Precio final (P2)",
            onChanged: (value) {
              ref
                  .read(inflationFormProvider.notifier)
                  .onFinalPriceChanged(double.tryParse(value) ?? 0);
            },
            errorMessage: inflationForm.isFormPosted && inflationForm.finalPrice <= 0
                ? "Ingrese un precio final válido"
                : null,
          ),
          const SizedBox(height: 40),
          CustomFilledButton(
            onPressed: ref.read(inflationFormProvider.notifier).calculateInflation,
            buttonColor: Colors.blue,
            child: const Text("Calcular"),
          ),
          const SizedBox(height: 20),
          if (inflationForm.isFormPosted)
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  const Text("RESULTADO:", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(
                    "La inflación calculada es de: ${inflationForm.result.toStringAsFixed(2)}%",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
