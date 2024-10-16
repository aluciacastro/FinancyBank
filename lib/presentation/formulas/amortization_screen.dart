// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/amortizacion/amortization_provider.dart';
import '../widget/shared/custom_background.dart';
import '../widget/shared/custom_dropdown_menu.dart';
import '../widget/shared/custom_filled_button.dart';
import '../widget/shared/custom_text_form_field.dart';
import '../widget/shared/header.dart'; 
class AmortizationScreen extends ConsumerWidget {
  const AmortizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amortizationForm = ref.watch(amortizationProvider);
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
              Text("Selecciona el tipo de amortización:", style: textStyles.bodyMedium),

              CustomDropDownMenu(
                hintText: "Seleccionar",
                options: const {'Francesa': 'Francesa', 'Alemana': 'Alemana', 'Americana': 'Americana'},
                onSelected: (value) {
                  ref.read(amortizationProvider.notifier).onAmortizationTypeChanged(value!);
                },
                errorText: amortizationForm.isFormPosted && amortizationForm.amortizationType.isEmpty
                    ? "Seleccione un tipo de amortización"
                    : null,
              ),

              const SizedBox(height: 20),

              CustomTextFormField(
                label: "Capital",
                onChanged: (value) {
                  ref.read(amortizationProvider.notifier).onCapitalChanged(double.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                label: "Tasa de Interés (%)",
                onChanged: (value) {
                  ref.read(amortizationProvider.notifier).onInterestRateChanged(double.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                label: "Periodos",
                onChanged: (value) {
                  ref.read(amortizationProvider.notifier).onPeriodsChanged(int.tryParse(value) ?? 0);
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomFilledButton(
                  onPressed: () {
                    ref.read(amortizationProvider.notifier).calculateAmortization();
                  },
                  child: const Text("Calcular"),
                  buttonColor: const Color.fromARGB(255, 0, 140, 255),
                ),
              ),

              const SizedBox(height: 20),

              if (amortizationForm.isFormPosted)
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 0, 140, 255),
                  ),
                  child: SizedBox(
                    height: 200, // Ajusta esta altura según la necesidad
                    child: ListView.builder(
                      shrinkWrap: true, // Permite que el ListView funcione correctamente en Column
                      itemCount: amortizationForm.payments.length,
                      itemBuilder: (context, index) {
                        final payment = amortizationForm.payments[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pago ${index + 1}:",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Usamos toStringAsFixed(2) para mostrar 2 decimales
                            Text("Cuota: ${payment['cuota']!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white)),
                            Text("Interés: ${payment['interes']!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white)),
                            Text("Amortización: ${payment['amortizacion']!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 6),
                            ],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
