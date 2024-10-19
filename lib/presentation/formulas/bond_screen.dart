import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:cesarpay/providers/bono/BondFormProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class BondScreen extends ConsumerWidget {
  const BondScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bondForm = ref.watch(bondProvider);
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
              Text("Cálculo de Bonos", style: textStyles.bodyLarge),

              const Divider(
                color: Color.fromARGB(255, 0, 140, 255),
                thickness: 5,
                indent: 50,
                endIndent: 50,
              ),

              const SizedBox(height: 20),
              const Concept(
                definition:
                    "El valor presente de un bono es el valor actual de los flujos de efectivo futuros que generará, descontados a una tasa específica.",
                important: ["Valor Presente", "bono", "flujos de efectivo", "tasa de descuento"],
                equations: [
                  r"V_0 = \sum_{t=1}^{n} \frac{C}{(1 + r)^t} + \frac{M}{(1 + r)^n}"
                ],
              ),

              const SizedBox(height: 20),
              CustomTextFormField(
                label: "Valor Nominal",
                onChanged: (value) {
                  ref.read(bondProvider.notifier).onNominalValueChanged(double.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                label: "Tasa de Cupón (%)",
                onChanged: (value) {
                  ref.read(bondProvider.notifier).onCouponRateChanged(double.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                label: "Tasa de Descuento (%)",
                onChanged: (value) {
                  ref.read(bondProvider.notifier).onDiscountRateChanged(double.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                label: "Número de Periodos",
                onChanged: (value) {
                  ref.read(bondProvider.notifier).onPeriodsChanged(int.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomFilledButton(
                  onPressed: () {
                    ref.read(bondProvider.notifier).calculateBond();
                  },
                  buttonColor: const Color.fromARGB(255, 0, 140, 255),
                  child: const Text("Calcular"),
                ),
              ),

              const SizedBox(height: 20),

              if (bondForm.isFormPosted)
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
                      if (bondForm.isFormPosted)
                        Text(
                          "El valor presente del bono es: \$${
                              bondForm.result.toStringAsFixed(2)}",
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
