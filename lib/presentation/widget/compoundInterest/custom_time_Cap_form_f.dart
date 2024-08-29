import 'package:cesarpay/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/domain.dart';
import '../shared/custom_filled_button.dart';
import 'custom_text_form_field_M.dart';


class CustomTimeCapFormField extends ConsumerWidget {
  const CustomTimeCapFormField({
    super.key,
    required this.compoundFromState,
    required this.keyOptions, required ProviderContainer container,
  });

  final CompoundFromState compoundFromState;
  final List<CompoundVariable> keyOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capitalizationPeriod = ref.watch(compoundFormProvider).capitalizationPeriod;

    return CustomTextFormFieldCap(
      icon: Icons.calendar_today,
      enable: compoundFromState.variable != keyOptions.last &&
          compoundFromState.variable != keyOptions[3],
      label: "Tiempo",
      controller: TextEditingController(
        text: compoundFromState.time.value.toStringAsFixed(3),
      ),
      errorMessage: compoundFromState.isFormPosted &&
              compoundFromState.variable != CompoundVariable.time &&
              compoundFromState.variable != CompoundVariable.interestRate2
          ? compoundFromState.time.errorMessage
          : null,
      suffixIconPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController yearsController = TextEditingController();
            TextEditingController monthsController = TextEditingController();
            TextEditingController daysController = TextEditingController();
            TextEditingController semesterController = TextEditingController();
            TextEditingController quaterController = TextEditingController();
            TextEditingController bimesterController = TextEditingController();

            return AlertDialog(
                title: const Text("Establecer Tiempo"),
                content: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: yearsController,
                          decoration: const InputDecoration(labelText: 'Años'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: monthsController,
                          decoration: const InputDecoration(labelText: 'Meses'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: daysController,
                          decoration: const InputDecoration(labelText: 'Días'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: semesterController,
                          decoration:
                              const InputDecoration(labelText: 'Semestres'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: quaterController,
                          decoration:
                              const InputDecoration(labelText: 'Trimestres'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: bimesterController,
                          decoration:
                              const InputDecoration(labelText: 'Bimestres'),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CustomFilledButton(
                            onPressed: () {
                              double result;

                              int days = int.tryParse(daysController.text) ?? 0;
                              int months =
                                  int.tryParse(monthsController.text) ?? 0;
                              int years =
                                  int.tryParse(yearsController.text) ?? 0;
                              int semester =
                                  int.tryParse(semesterController.text) ?? 0;
                              int quater =
                                  int.tryParse(quaterController.text) ?? 0;
                              int bimester =
                                  int.tryParse(bimesterController.text) ?? 0;

                              result = formulaTiempo(
                                  years,
                                  months,
                                  days,
                                  semester,
                                  quater,
                                  bimester,
                                  capitalizationPeriod);

                              Navigator.of(context).pop();

                              ref.read(compoundFormProvider.notifier).onTimeChanged(result);
                            },
                            child: const Text("Establecer"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}