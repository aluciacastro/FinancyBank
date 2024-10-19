import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:cesarpay/providers/alternative_inversion/InvestmentEvaluationFormState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class InvestmentEvaluationScreen extends ConsumerWidget {
  const InvestmentEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investmentForm = ref.watch(investmentProvider);
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
              Text("Evaluación de Alternativas de Inversión", style: textStyles.bodyLarge),

              const Divider(
                color: Color.fromARGB(255, 0, 140, 255),
                thickness: 5,
                indent: 50,
                endIndent: 50,
              ),

              const SizedBox(height: 20),
              const Concept(
                definition:
                    "El Valor Presente Neto (VPN) se utiliza para evaluar la rentabilidad de una inversión al descontar los flujos de caja futuros a una tasa de descuento determinada.",
                important: ["Valor Presente Neto (VPN)", "flujos de caja", "tasa de descuento"],
                equations: [
                  r"VPN = \sum_{t=1}^{n} \frac{FC_t}{(1 + r)^t} - I_0"
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Ingrese los flujos de caja proyectados:",
                style: textStyles.bodyMedium,
              ),
              
              const SizedBox(height: 15),

              for (int i = 0; i < investmentForm.cashFlows.length + 1; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CustomTextFormField(
                    label: "Flujo de caja año ${i + 1}",
                    onChanged: (value) {
                      ref.read(investmentProvider.notifier).onCashFlowChanged(i, double.tryParse(value) ?? 0);
                    },
                  ),
                ),
              
              const SizedBox(height: 20),
              CustomTextFormField(
                label: "Tasa de Descuento (%)",
                onChanged: (value) {
                  ref.read(investmentProvider.notifier).onDiscountRateChanged(double.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomFilledButton(
                  onPressed: () {
                    ref.read(investmentProvider.notifier).calculateNPV();
                  },
                  buttonColor: const Color.fromARGB(255, 0, 140, 255),
                  child: const Text("Calcular VPN"),
                ),
              ),
              
              const SizedBox(height: 20),
              if (investmentForm.isFormPosted)
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
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
                        "El Valor Presente Neto es: \$${
                          investmentForm.npvResult.toStringAsFixed(2)
                        }",
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
