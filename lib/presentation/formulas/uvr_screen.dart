import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/UVR/uvr_notifier.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class UVRScreen extends StatelessWidget {
  const UVRScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text("Cálculo de Unidad de Valor Real (UVR)", style: Theme.of(context).textTheme.titleLarge),
              const Divider(
                color: Color.fromARGB(255, 0, 140, 255),
                thickness: 5,
                indent: 50,
                endIndent: 50,
              ),
              const SizedBox(height: 20),
              const Concept(
                definition:
                    "La Unidad de Valor Real (UVR) es una medida utilizada en Colombia para calcular el valor de los créditos hipotecarios y otros instrumentos financieros indexados a la inflación.",
                important: ["Unidad de Valor Real (UVR)", "créditos hipotecarios", "inflación"],
                equations: [
                  r"UVR = C \cdot \left(1 + \frac{i}{100}\right)^n"
                ],
              ),
              const SizedBox(height: 30),
              const UVRForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class UVRForm extends ConsumerWidget {
  const UVRForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uvrFormState = ref.watch(uvrProvider);
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ingrese los datos:", style: textStyles.bodyMedium),
          const SizedBox(height: 15),

          //* Capital input
          CustomTextFormField(
            label: 'Capital',
            onChanged: (value) {
              ref
                  .read(uvrProvider.notifier)
                  .onCapitalChanged(double.tryParse(value) ?? 0);
            },
          ),
          const SizedBox(height: 15),

          //* Interest rate input
          CustomTextFormField(
            label: 'Tasa de Interés (%)',
            onChanged: (value) {
              ref
                  .read(uvrProvider.notifier)
                  .onInterestRateChanged(double.tryParse(value) ?? 0);
            },
          ),
          const SizedBox(height: 15),

          //* Periods input
          CustomTextFormField(
            label: 'Períodos',
            onChanged: (value) {
              ref
                  .read(uvrProvider.notifier)
                  .onPeriodsChanged(int.tryParse(value) ?? 0);
            },
          ),
          const SizedBox(height: 30),

          //* Calculate button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: CustomFilledButton(
              onPressed: () {
                ref.read(uvrProvider.notifier).calculateUVR();
              },
              buttonColor: const Color.fromARGB(255, 0, 140, 255),
              child: const Text('Calcular'),
            ),
          ),
          const SizedBox(height: 30),

          //* Result display
          if (uvrFormState.isFormPosted)
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
                    "El valor calculado de la UVR es: ${uvrFormState.result}",
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
