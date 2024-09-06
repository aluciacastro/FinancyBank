import 'package:cesarpay/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/compoundInterest/custom_time_Cap_form_f.dart';
import '../widget/operations/concep.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_dropdown_menu.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class CompoundInterestScreen extends StatelessWidget {
  const CompoundInterestScreen({super.key});

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
                child: const _CompoundInterestForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompoundInterestForm extends ConsumerWidget {
  const _CompoundInterestForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compoundForm = ref.watch(compoundFormProvider);
    final keyOptions = compoundForm.menuOptions.keys.toList();
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Interés Compuesto", style: textStyles.titleLarge),
            const Divider(
              color: Color.fromARGB(255, 31, 8, 236),
              thickness: 5,
              indent: 6,
              endIndent: 6,
            ),
            const SizedBox(height: 20),
            const Concept(
              definition:
                  "El Interes compuesto es Es la acumulación de intereses que se generan en un período determinado de tiempo por un capital inicial o principal a una tasa de interés durante determinados periodos de imposición, de manera que los intereses que se obtienen al final de los períodos de inversión no se reinvierten al capital inicial, o sea, se capitalizan.",
              important: ["Interes compuesto"],
              equations: [
                r"I = {(\frac {MC}{C})^1/n-1}",
                r"\text{\textbardbl}",
                r"I_C = {MC-C}",
                r"M = {C(1+i)^n}", 
                r"",
                r"",
                r"\text{\textbardbl}",
                r"C = {\frac {MC} {(1+i)^n}} ",
                r"M = {\scriptsize\frac {Log MC - Log C} {Log (1+i)}} ",
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Calculadora de Interés Compuesto",
              style: GoogleFonts.montserrat().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),
            Text("Selecciona variable a calcular", style: textStyles.bodyLarge),
            const SizedBox(height: 10),

            CustomDropDownMenu(
              hintText: "Seleccionar",
              options: compoundForm.menuOptions,
              onSelected: (value) {
                ref
                    .read(compoundFormProvider.notifier)
                    .onOptionsCompoundChanged(value!);
              },
              errorText: compoundForm.isFormPosted &&
                      compoundForm.variable == CompoundVariable.none
                  ? "Seleccione la variable a calcular"
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              "Completa la siguiente información",
              style: GoogleFonts.montserrat().copyWith(
                color: const Color.fromARGB(255, 31, 8, 236),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),

            //Form
            CustomTextFormField(
              enable: compoundForm.variable != keyOptions[0],
              label: "Monto compuesto",
              onChanged: (value) {
                ref
                    .read(compoundFormProvider.notifier)
                    .onAmountChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: compoundForm.isFormPosted &&
                      compoundForm.variable != keyOptions.first
                  ? compoundForm.amount.errorMessage
                  : null,
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              enable: compoundForm.variable != keyOptions[1],
              label: "Capital",
              onChanged: (value) {
                ref
                    .read(compoundFormProvider.notifier)
                    .onCapitalChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: compoundForm.isFormPosted &&
                      compoundForm.variable != CompoundVariable.capital
                  ? compoundForm.capital.errorMessage
                  : null,
            ),
            const SizedBox(height: 15),

            CustomTextFormField(
              enable: compoundForm.variable != keyOptions[2] &&
                  compoundForm.variable != keyOptions[3],
              label: "Tasa de interés (%)",
              onChanged: (value) {
                ref
                    .read(compoundFormProvider.notifier)
                    .onInterestRateChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: compoundForm.isFormPosted &&
                      compoundForm.variable != CompoundVariable.interestRate &&
                      compoundForm.variable != CompoundVariable.interestRate2
                  ? compoundForm.capInterestRate.errorMessage
                  : null,
            ),

            const SizedBox(height: 25),
            Text("Seleccione Tipo de tasa de interes",
                style: textStyles.bodyLarge),
            const SizedBox(height: 10),

            CustomDropDownMenu(
              hintText: "Seleccionar ",
              options: compoundForm.menuOptionsTypeInterest,
              onSelected: (value) {
                ref
                    .read(compoundFormProvider.notifier)
                    .onOptionsTypeInterestRateChanged(value!);
              },
              errorText: compoundForm.isFormPosted &&
                      compoundForm.variable == CompoundVariable.none
                  ? "Seleccione Tipo de tasa de interes"
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              "Seleccione Capitalizacion",
              style: textStyles.bodyLarge,
            ),
            const SizedBox(height: 10),

            CustomDropDownMenu(
              hintText: "Seleccionar ",
              options: compoundForm.menuOptionsCap,
              onSelected: (value) {
                ref
                    .read(compoundFormProvider.notifier)
                    .onOptionsCapitalizationChanged(value!);
              },
              errorText: compoundForm.isFormPosted &&
                      compoundForm.variable == CompoundVariable.none
                  ? "Seleccione Capitalizacion"
                  : null,
            ),

            const SizedBox(height: 30),

            CustomTimeCapFormField(
                compoundFromState: compoundForm,
                keyOptions: keyOptions,
                ref: ref),

            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                onPressed: ref.read(compoundFormProvider.notifier).calculate,
                child: const Text("Calcular"),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity - 30,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 70, 181, 251),
              ),
              child: Column(
                children: [
                  const Text(
                    "RESULTADO:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  if (compoundForm.isFormPosted)
                    Text(
                      _getResultText(
                          compoundForm.variable, compoundForm.result),
                      style: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

String _getResultText(CompoundVariable variable, double result) {
  switch (variable) {
    case CompoundVariable.amount:
      return "El Monto obtenido es de: \$$result";
    case CompoundVariable.capital:
      return "El Capital obtenido es de: \$$result";
    case CompoundVariable.interestRate:
      return "La Tasa de Interés obtenida es de: $result%";
    case CompoundVariable.interestRate2:
      return "La Tasa de Interés obtenida es de: $result%";
    case CompoundVariable.time:
      return "El Tiempo obtenido es de: $result";
    default:
      return "";
  }
}
