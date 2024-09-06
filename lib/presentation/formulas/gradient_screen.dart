import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/gradient/gradient_from_provider.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_dropdown_menu.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart';

class GradientScreen extends StatelessWidget {
  const GradientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      height: 200,
      showArrow: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
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
                child: const _GradientForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientForm extends ConsumerWidget {
  const _GradientForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradienForm = ref.watch(gradientFormProvider);
    // final keyOptions = gradienForm.menuOptions.keys.toList();
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Gradiente", style: textStyles.titleLarge),
            const Divider(
              color: Color.fromARGB(255, 0, 140, 255),
              thickness: 5,
              indent: 6,
              endIndent: 6,
            ),
            const SizedBox(height: 20),
            const Concept(
              definition:
                  "Un Gradiente o serie variable es una serie de cuotas que no son iguales, pero tienen una constante de variación. Esta puede ser un valor, lo que da origen al gradiente Aritmetico o Lineal, o un porcentaje, lo que genera el gradiente Geometrico; Igualmente, esa variación puede ser positiva o negativa, por lo que los gradientes pueden ser Crecientes (C) o Decrecientes (D)",
              important: ["Gradiente", "no son iguales", "Crecientes", "Decrecientes"],
              equations: [
                r"Aritmetico: CyD",
                r" \vdots\scriptsize V_p = A\Bigg\lbrack~ \frac {1-(1+i)^-n} {i}  \Bigg\rbrack + \frac {G}{i} \Bigg\lbrack~ \frac {1-(1+i)^-n} {i}-\frac {n} {(1+i)^n} \Bigg\rbrack",
                r"",
                r" \vdots\scriptsize V_f = A\Bigg\lbrack~ \frac {(1+i)^n - 1} {i}  \Bigg\rbrack + \frac {G}{i} \Bigg\lbrack~ \frac {(1+i)^n - 1} {i} - n \Bigg\rbrack ",
                
                r" \vdots\scriptsize V_p = A\Bigg\lbrack~ \frac {1-(1+i)^-n} {i}  \Bigg\rbrack + \frac {G}{i} \Bigg\lbrack~ \frac {1-(1+i)^-n} {i}-\frac {n} {(1+i)^n} \Bigg\rbrack",
                r"",
                r" \vdots\scriptsize V_f = A\Bigg\lbrack~ \frac {(1+i)^n - 1} {i}  \Bigg\rbrack + \frac {G}{i} \Bigg\lbrack~ \frac {(1+i)^n - 1} {i} - n \Bigg\rbrack ",
                r"Geometrico: ",
                r"", r"",
                r"\vdots \scriptsize V_p = \Bigg\lbrack~ \frac {A [(1+G)^n (1+i)^-n - 1]} {G - i} \Bigg\rbrack (C) ",
                r"\vdots \scriptsize V_f = \Bigg\lbrack~ \frac {A [(1+G)^n (1+i)^n ]} {G - i} \Bigg\rbrack (C)",
                r"\vdots \scriptsize V_p = \Bigg\lbrack~ \frac {A [(1+G)^n (1+i)^-n - 1]} {G + i} \Bigg\rbrack (D)",
                r"\vdots \scriptsize V_f = \Bigg\lbrack~ \frac {A [(1+G)^n - (1+i)^n ]} {G + i} \Bigg\rbrack (D)",
              ],
            ),

            const SizedBox(height: 20),
            Text(
              "Calculadora de Gradientes",
              style: GoogleFonts.montserrat().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),
            Text("Selecciona tipo de Gradiente a calcular",
                style: textStyles.bodyLarge),
            const SizedBox(height: 10),
            CustomDropDownMenu(
              hintText: "Seleccionar",
              options: gradienForm.menuOptions,
              onSelected: (value) {
                ref
                    .read(gradientFormProvider.notifier)
                    .onOptionsGradientChanged(value!);
              },
              errorText: gradienForm.isFormPosted &&
                      gradienForm.typeGradiente == GradientType.none
                  ? "Seleccione tipo de Gradiente a calcular"
                  : null,
            ),
            const SizedBox(height: 20),
            if (gradienForm.typeGradiente != GradientType.none)
              Column(
                children: [
                  Text("Selecciona variable a calcular",
                      style: textStyles.bodyLarge),
                  const SizedBox(height: 10),
                  CustomDropDownMenu(
                    hintText: "Seleccionar",
                    options: gradienForm
                        .getVariableOptions(gradienForm.typeGradiente),
                    onSelected: (value) {
                      if (gradienForm.typeGradiente == GradientType.aritmetic) {
                        ref
                            .read(gradientFormProvider.notifier)
                            .onOptionsGradientVariableAChanged(value!);
                      } else if (gradienForm.typeGradiente ==
                          GradientType.geometric) {
                        ref
                            .read(gradientFormProvider.notifier)
                            .onOptionsGradientVariableGChanged(value!);
                      }
                    },
                    errorText: gradienForm.isFormPosted &&
                            ((gradienForm.typeGradiente ==
                                        GradientType.aritmetic &&
                                    gradienForm.variableA ==
                                        GradientVariableA.none) ||
                                (gradienForm.typeGradiente ==
                                        GradientType.geometric &&
                                    gradienForm.variableG ==
                                        GradientVariableG.none))
                        ? "Seleccione variable a calcular"
                        : null,
                  ),
                ],
              ),

            const SizedBox(height: 20),
            Text(
              "Completa la siguiente información",
              style: GoogleFonts.montserrat().copyWith(
                color: const Color.fromARGB(255, 0, 140, 255),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),

            //Form
            CustomTextFormField(
              label: "Serie de pagos (A)",
              onChanged: (value) {
                ref
                    .read(gradientFormProvider.notifier)
                    .onPaymentSeriesChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: gradienForm.isFormPosted &&
                      ((gradienForm.typeGradiente == GradientType.aritmetic &&
                              gradienForm.variableA !=
                                  GradientVariableA.none) ||
                          (gradienForm.typeGradiente ==
                                  GradientType.geometric &&
                              gradienForm.variableG != GradientVariableG.none))
                  ? gradienForm.paymentSeries.errorMessage
                  : null,
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: "Variación (G)",
              onChanged: (value) {
                ref
                    .read(gradientFormProvider.notifier)
                    .onVariationGChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: gradienForm.isFormPosted &&
                      ((gradienForm.typeGradiente == GradientType.aritmetic &&
                              gradienForm.variableA !=
                                  GradientVariableA.none) ||
                          (gradienForm.typeGradiente ==
                                  GradientType.geometric &&
                              gradienForm.variableG != GradientVariableG.none))
                  ? gradienForm.paymentSeries.errorMessage
                  : null,
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: "Tasa de Interés (%) (I)",
              onChanged: (value) {
                ref
                    .read(gradientFormProvider.notifier)
                    .onInterestRateChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: gradienForm.isFormPosted &&
                      ((gradienForm.typeGradiente == GradientType.aritmetic &&
                              gradienForm.variableA !=
                                  GradientVariableA.none) ||
                          (gradienForm.typeGradiente ==
                                  GradientType.geometric &&
                              gradienForm.variableG != GradientVariableG.none))
                  ? gradienForm.paymentSeries.errorMessage
                  : null,
            ),
            const SizedBox(height: 15),
            CustomTextFormField(
              label: "Número de períodos (n)",
              onChanged: (value) {
                ref
                    .read(gradientFormProvider.notifier)
                    .onNumPeriodChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: gradienForm.isFormPosted &&
                      ((gradienForm.typeGradiente == GradientType.aritmetic &&
                              gradienForm.variableA !=
                                  GradientVariableA.none) ||
                          (gradienForm.typeGradiente ==
                                  GradientType.geometric &&
                              gradienForm.variableG != GradientVariableG.none))
                  ? gradienForm.paymentSeries.errorMessage
                  : null,
            ),

            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                onPressed: ref.read(gradientFormProvider.notifier).calculate,
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
                color: const Color.fromARGB(255, 0, 140, 255),
              ),
              child: Column(
                children: [
                  const Text(
                    "RESULTADO:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  if (gradienForm.isFormPosted)
                    Text(
                      _getResultText(
                        gradienForm.variableA,
                        gradienForm.variableG,
                        gradienForm.result,
                      ),
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

String _getResultText(
    GradientVariableA variableA, GradientVariableG variableG, double result) {
  switch (variableA) {
    case GradientVariableA.presentValueAIncreasing:
      return "El valor presente creciente A es: \$$result";
    case GradientVariableA.futureValueAIncreasing:
      return "El valor futuro creciente A es: \$$result";
    case GradientVariableA.presentValueADecreasing:
      return "El valor presente decreciente A es: \$$result";
    case GradientVariableA.futureValueADecreasing:
      return "El valor futuro decreciente A es: \$$result";
    case GradientVariableA.none:
      break;
  }
  switch (variableG) {
    case GradientVariableG.presentValueGIncreasing:
      return "El valor presente creciente G es: \$$result";
    case GradientVariableG.futureValueGIncreasing:
      return "El valor futuro creciente G es: \$$result";
    case GradientVariableG.presentValueGDecreasing:
      return "El valor presente decreciente G es: \$$result";
    case GradientVariableG.futureValueGDecreasing:
      return "El valor futuro decreciente G es: \$$result";
    case GradientVariableG.none:
      break;
  }
  return "";
}
