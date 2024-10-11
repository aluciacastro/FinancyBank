import 'package:cesarpay/presentation/widget/operations/concep.dart';
import 'package:cesarpay/presentation/widget/shared/custom_background.dart';
import 'package:cesarpay/presentation/widget/shared/custom_dropdown_menu.dart';
import 'package:cesarpay/presentation/widget/shared/custom_filled_button.dart';
import 'package:cesarpay/presentation/widget/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tir/tir_form_provider.dart';
import '../widget/shared/header.dart';
import '../widget/tirr/cashflow_text_field.dart';

class TirScreen extends StatelessWidget {
  const TirScreen({super.key});

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
                height: 700,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _TirForm(),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _TirForm extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final tirForm = ref.watch(tirFormProvider);
    final tirOptions = tirForm.menuOptions.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("TIR", style: textStyles.titleLarge),
            const Divider(
              color: Color.fromARGB(255, 0, 140, 255),
              thickness: 5,
              indent: 122,
              endIndent: 122,
            ),
            const SizedBox(height: 20),
            const Concept(
              definition: "La Tasa Interna de Retorno o TIR es "
              "la tasa de interés o de rentabilidad que ofrece "
              "una inversión. Así, se puede decir "
              "que la Tasa Interna de Retorno es el ""porcentaje de "
              "beneficio o pérdida que conlleva cualquier inversión.​​",

              important: [
                "Tasa Interna de Retorno", 
                "TIR", "rentabilidad", "inversión"
              ],

              equations: [
                r"VAN = -I_0 + \sum_{n=1}^{N}{\frac C {(1 + r)^n}} = 0",
              ],
            ),

            //* FORM
            const SizedBox(height: 30),
            Text("Variable a Calcular", style: textStyles.bodyMedium),
            const SizedBox(height: 10),

            CustomDropDownMenu(
              hintText: "Seleccionar",
              options: tirForm.menuOptions,
              onSelected: (value) {
                ref
                  .read(tirFormProvider.notifier)
                  .onTirVaraibleChanged(value);
                    
              },
              errorText: tirForm.isFormPosted && tirForm.variable == TirVariable.none
              ? "Seleccione la variable a calcular"
              : null,
            ),

            const SizedBox(height: 15),

            const SizedBox(height: 30),
            Text("Completa la siguiente información:",
              style: textStyles.bodyMedium?.copyWith(
                color: const Color.fromARGB(255, 0, 140, 255),
            )),

            const SizedBox(height: 15),

            CustomTextFormField(
              enable: tirForm.variable != tirOptions[1]
              && tirForm.variable != tirOptions[0],
              label: "VAN",
              onChanged: (value) {
                ref.read(tirFormProvider.notifier)
                .onVanChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: tirForm.isFormPosted && tirForm.variable != TirVariable.van
              && tirForm.variable != TirVariable.tir
              ? tirForm.van.errorMessage
              : null,
            ),

            const SizedBox(height: 15),

            CustomTextFormField(
              enable: tirForm.variable != tirOptions[2],
              label: "Inversión",
              onChanged: (value) {
                ref.read(tirFormProvider.notifier)
                .onInvestmentChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: tirForm.isFormPosted && tirForm.variable != TirVariable.investment
              ? tirForm.investment.errorMessage
              : null,
            ),

            const SizedBox(height: 15),

            CustomTextFormField(
              enable: tirForm.variable != tirOptions[0],
              label: "TIR",
              onChanged: (value) {
                ref.read(tirFormProvider.notifier)
                .onTirChanged(double.tryParse(value) ?? 0);
              },
              errorMessage: tirForm.isFormPosted && tirForm.variable != TirVariable.tir
              ? tirForm.tir.errorMessage
              : null,
            ),

            const SizedBox(height: 15),

            CashFlowTextField(
              text: tirForm.cashflow.map((cf) => cf.value).toString(),
              onPressed: ref.read(tirFormProvider.notifier).onCashFlowChanged,
              errorMessage: tirForm.isFormPosted && tirForm.cashflow.isEmpty
              ? "Digite los flujos de caja"
              : null
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                onPressed:
                  ref.read(tirFormProvider.notifier).calculate,
                child: const Text("Calcular"),
              ),
            ),

            const SizedBox(height: 15),

            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(10),
              width: double.infinity - 30,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 0, 140, 255),
              ),
              child: Text(
                tirForm.isFormPosted && tirForm.isValid
                ? _getResultText(tirForm.variable, tirForm.result)
                : "RESULTADO:",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getResultText(TirVariable variable, double result) {
  switch (variable) {
    case TirVariable.none:
      return "RESULTADO:";
    case TirVariable.van:
      return "El valor actual neto obtenido es de: \$$result";
    case TirVariable.investment:
      return "La inversión hecha es de: \$$result";
    case TirVariable.tir:
      return "La tasa interna de retorno obtenida es de: \$$result";
    default:
      return "";
  }
}
}