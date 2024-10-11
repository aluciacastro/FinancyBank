import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/anuaty/annuity_form_provider.dart';
import '../widget/operations/concep.dart';
import '../widget/operations/custom_time_form_field.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_dropdown_menu.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class AnnuitiesScreen extends StatelessWidget {
  const AnnuitiesScreen({super.key});

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
                height: 685,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const _AnnuitiesForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnuitiesForm extends ConsumerWidget {
  const _AnnuitiesForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final annuityForm = ref.watch(annuityFormProvider);
    final keyOptions = annuityForm.menuOptions.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Anualidades", style: textStyles.titleLarge),
            const Divider(
              color: Color.fromARGB(255, 0, 140, 255),
              thickness: 5,
              indent: 60,
              endIndent: 60,
            ),
            const SizedBox(height: 20),
            const Concept(
              spaicing: 3,
              definition:
                  "Anualidad se refiere a un conjunto de pagos, depósitos o retiros realizados por la misma cantidad a intervalos iguales de tiempo. A los cuales se aplica interés compuesto.",
              important: ["Anualidad", "intervalos iguales"],
              equations: [
                r"VF = A[\frac {(1+i)^n-1} {i}],",
                r"VA = A[ \frac {1-(1+i)^{-n}} {i}]",
              ],
            ),

            //* FORM
            const SizedBox(height: 30),
            Text("Variable a Calcular", style: textStyles.bodyMedium),
            const SizedBox(height: 10),

            CustomDropDownMenu(
              hintText: "Seleccionar",
              options: annuityForm.menuOptions,
              onSelected: (value) {
                ref
                    .read(annuityFormProvider.notifier)
                    .onOptionsAnnuitiesChanged(value);
              },
              errorText: annuityForm.isFormPosted &&
                      annuityForm.variable == AnnuityVariable.none
                  ? "Seleccione la variable a calcular"
                  : null,
            ),

            const SizedBox(height: 30),
            Text("Completa la siguiente información:",
                style: textStyles.bodyMedium?.copyWith(
                  color: const Color.fromARGB(255, 0, 140, 255),
                )),

            const SizedBox(height: 15),
            CustomTextFormField(
              enable: annuityForm.variable != keyOptions[0] &&
                  annuityForm.variable != keyOptions[1],
              label: "Valor Final o Monto",
              onChanged: (value) {
                ref
                    .read(annuityFormProvider.notifier)
                    .onAmountChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: annuityForm.isFormPosted &&
                      annuityForm.variable != keyOptions[0] &&
                      annuityForm.variable != keyOptions[1]
                  ? annuityForm.amount.errorMessage
                  : null,
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              enable: annuityForm.variable != keyOptions[2],
              label: "Valor Anualidad",
              onChanged: (value) {
                ref
                    .read(annuityFormProvider.notifier)
                    .onAnnuityValueChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: annuityForm.isFormPosted &&
                      annuityForm.variable != keyOptions[2]
                  ? annuityForm.annuityValue.errorMessage
                  : null,
            ),

            const SizedBox(height: 20),
            const Text("Tipo de capitalización"),
            const SizedBox(height: 15),

            CustomDropDownMenu(
              enable: true,
              hintText: "Seleccionar",
              options: annuityForm.capitalizationOptions,
              onSelected: (value) {
                ref
                    .read(annuityFormProvider.notifier)
                    .onCapitalizationChanged(value!);
              },
              errorText: annuityForm.isFormPosted &&
                      annuityForm.capitalization == CapitalizationInterest.none
                  ? "Seleccione la capitalización"
                  : null,
            ),

            const SizedBox(height: 20),
            const Text("Tipo de Tasa de Interes"),
            const SizedBox(height: 15),

            CustomDropDownMenu(
              enable: true,
              hintText: "Seleccionar",
              options: annuityForm.capitalizationOptions,
              onSelected: (value) {
                ref
                    .read(annuityFormProvider.notifier)
                    .onTypeInterestRateChanged(value!);
              },
              errorText: annuityForm.isFormPosted &&
                      annuityForm.capitalization == CapitalizationInterest.none
                  ? "Seleccione la tasa  de interés"
                  : null,
            ),

            const SizedBox(height: 15),
            CustomTextFormField(
              enable: true,
              label: "Tasa de Interés (%)",
              onChanged: (value) {
                ref
                    .read(annuityFormProvider.notifier)
                    .onInterestRateChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: annuityForm.isFormPosted
                  ? annuityForm.interestRate.errorMessage
                  : null,
            ),

            const SizedBox(height: 20),

            CustomTimeFormField(
              enable: annuityForm.variable != keyOptions[3],
              text: annuityForm.time.value.toStringAsFixed(3),
              setTime: ref.read(annuityFormProvider.notifier).onTimeChanged,
              errorMessage: annuityForm.isFormPosted &&
                      annuityForm.variable != AnnuityVariable.time
                  ? annuityForm.time.errorMessage
                  : null,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                onPressed: ref.read(annuityFormProvider.notifier).calculate,
                child: const Text("Calcular"),
              ),
            ),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity - 30,
              height: 100,
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
                  if (annuityForm.isFormPosted)
                    Text(
                      _getResultText(annuityForm.variable, annuityForm.result),
                      style: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getResultText(AnnuityVariable variable, String result) {
  switch (variable) {
    case AnnuityVariable.amount:
      return "El Monto obtenido es de: \$$result";
    case AnnuityVariable.annuityValue:
      return "El Capital obtenido es de: \$$result";
    case AnnuityVariable.annuity:
      return "El Valor de la anualidad obtenida es de: \$$result";
    case AnnuityVariable.time:
      return "El tiempo obtenido es de $result";

    default:
      return "";
  }
}
