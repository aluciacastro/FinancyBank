import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:cesarpay/presentation/widget/shared/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../widget/operations/custom_time_form_field.dart';
import '../widget/shared/custom_dropdown_menu.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';



class SimpleInterestScreen extends StatelessWidget {
  const SimpleInterestScreen({super.key});

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
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 600,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const _SimpleInterestForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleInterestForm extends ConsumerWidget {
  const _SimpleInterestForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simpleInterestForm = ref.watch(simpleFormProvider);
    final keyOptions = simpleInterestForm.menuOptions.keys.toList();
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Interés simple", style: textStyles.titleLarge),
            const Divider(
              color: Color.fromARGB(255, 31, 8, 236),
              thickness: 5,
              indent: 50,
              endIndent: 50,
            ),

            const SizedBox(height: 20),
            const Concept(
              definition:
                  "El interés simple (I), es el que se cobra sobre el capital (C) o Valor Presente (VP) por un cierto tiempo (t) expresado en años.",
              important: [
                "interés simple (I)",
                "capital (C)",
                "Valor Presente (VP)",
                "tiempo (t)"
              ],
              equations: [r"I = Cit"],
            ),

            //* FORM
            const SizedBox(height: 30),
            Text("Variable a Calcular", style: textStyles.bodyMedium),
            const SizedBox(height: 10),

            CustomDropDownMenu(
              hintText: "Seleccionar",
              options: simpleInterestForm.menuOptions,
              onSelected: (value) {
                ref
                    .read(simpleFormProvider.notifier)
                    .onOptionsSimpleChanged(value!);
              },
              errorText: simpleInterestForm.isFormPosted &&
                      simpleInterestForm.variable == SimpleVariable.none
                  ? "Seleccione la variable a calcular"
                  : null,
            ),

            const SizedBox(height: 30),
            Text("Completa la siguiente información:",
                style: textStyles.bodyMedium?.copyWith(
                  color: const Color.fromARGB(255, 31, 8, 236),
                )),

            const SizedBox(height: 15),

            CustomTextFormField(
              enable: simpleInterestForm.variable != keyOptions[1],
              label: "Capital",
              onChanged: (value) {
                ref
                    .read(simpleFormProvider.notifier)
                    .onCapitalChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: simpleInterestForm.isFormPosted &&
                      simpleInterestForm.variable != SimpleVariable.capital
                  ? simpleInterestForm.capital.errorMessage
                  : null,
            ),

            const SizedBox(height: 15),

            CustomTextFormField(
              enable: simpleInterestForm.variable != keyOptions[2] &&
                  simpleInterestForm.variable != keyOptions[0],
              label: "Interés",
              onChanged: (value) {
                ref
                    .read(simpleFormProvider.notifier)
                    .onInterestChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: simpleInterestForm.isFormPosted &&
                      simpleInterestForm.variable != SimpleVariable.interest &&
                      simpleInterestForm.variable != SimpleVariable.amount
                  ? simpleInterestForm.interest.errorMessage
                  : null,
            ),

            const SizedBox(height: 15),

            CustomTextFormField(
              enable: simpleInterestForm.variable != keyOptions[4],
              label: "Tasa de Interés (%)",
              onChanged: (value) {
                ref
                    .read(simpleFormProvider.notifier)
                    .onRateInterestChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: simpleInterestForm.isFormPosted &&
                      simpleInterestForm.variable != SimpleVariable.interestRate
                  ? simpleInterestForm.rateInterest.errorMessage
                  : null,
            ),

            const SizedBox(height: 15),

            CustomTimeFormField(
              enable: simpleInterestForm.variable != keyOptions[3],
              text: simpleInterestForm.time.value.toStringAsFixed(3),
              setTime: ref.read(simpleFormProvider.notifier).onTimeChanged,
              errorMessage: simpleInterestForm.isFormPosted &&
                      simpleInterestForm.variable != SimpleVariable.time
                  ? simpleInterestForm.time.errorMessage
                  : null,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                onPressed: ref.read(simpleFormProvider.notifier).calculate,
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
                color: const Color.fromARGB(255, 70, 181, 251),
              ),
              child: Column(
                children: [
                  const Text(
                    "RESULTADO:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  if (simpleInterestForm.isFormPosted)
                    Text(
                      _getResultText(simpleInterestForm.variable,
                          simpleInterestForm.result),
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

String _getResultText(SimpleVariable variable, String result) {
  switch (variable) {
    case SimpleVariable.amount:
      return "El Monto obtenido es de: \$$result";
    case SimpleVariable.capital:
      return "El Capital obtenido es de: \$$result";
    case SimpleVariable.interestRate:
      return "La Tasa de Interés obtenida es de: $result%";
    case SimpleVariable.time:
      return "El Tiempo obtenido es de: $result";
    case SimpleVariable.interest:
      return "El Interés obtenido es de \$$result";
    default:
      return "";
  }
}
