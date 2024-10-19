import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:cesarpay/providers/inflation/inflationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class InflationScreen extends ConsumerWidget {
  const InflationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inflationForm = ref.watch(inflationProvider);
    final textStyles = Theme.of(context).textTheme;

    return CustomBackground(
      height: 200,
      showArrow: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const Divider(
                color: Color.fromARGB(255, 0, 140, 255),
                thickness: 5,
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 20),
              Text("Cálculo de Inflación", style: textStyles.titleLarge),
              const Divider(
                color: Color.fromARGB(255, 0, 140, 255),
                thickness: 5,
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 20),
              const Concept(
                definition:
                    "La inflación mide el aumento del nivel de precios de bienes y servicios en un período de tiempo.",
                important: ["inflación", "nivel de precios"],
                equations: [
                  r"I = \frac{P_f - P_i}{P_i} \times 100"
                ],
              ),
              const SizedBox(height: 30),
              Text("Ingrese los valores necesarios:", style: textStyles.bodyMedium),
              const SizedBox(height: 15),

              CustomTextFormField(
                label: "Precio Final (P_f)",
                onChanged: (value) {
                  ref.read(inflationProvider.notifier).onFinalPriceChanged(double.tryParse(value) ?? 0);
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                label: "Precio Inicial (P_i)",
                onChanged: (value) {
                  ref.read(inflationProvider.notifier).onInitialPriceChanged(double.tryParse(value) ?? 0);
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomFilledButton(
                  onPressed: () {
                    ref.read(inflationProvider.notifier).calculateInflation();
                  },
                  buttonColor: const Color.fromARGB(255, 0, 140, 255),
                  child: const Text("Calcular"),
                ),
              ),
              const SizedBox(height: 20),

              if (inflationForm.isFormPosted)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 0, 140, 255),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "RESULTADO:",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "La Inflación es de: ${inflationForm.inflationResult.toStringAsFixed(2)}%",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
