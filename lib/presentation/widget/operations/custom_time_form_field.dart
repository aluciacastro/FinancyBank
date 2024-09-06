import 'package:cesarpay/presentation/widget/shared/custom_filled_button.dart';
import 'package:cesarpay/presentation/widget/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomTimeFormField extends StatelessWidget {
  final bool? enable;
  final String label;
  final String? text;
  final void Function(double) setTime;
  final String? errorMessage;

  const CustomTimeFormField({
    super.key,
    this.enable,
    this.label = "Tiempo en Años",
    this.text,
    this.errorMessage,
    required this.setTime,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      enable: enable,
      readOnly: true,
      label: label,
      controller: TextEditingController(
        text: text,
      ),
      suffixIcon: IconButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => _TimeForm(setTime));
        },
        icon: const Icon(Icons.calendar_today),
      ),
      errorMessage: errorMessage,
    );
  }
}

class _TimeForm extends StatefulWidget {
  final void Function(double) setTime;

  const _TimeForm(this.setTime);

  @override
  State<_TimeForm> createState() => _TimeFormState();
}

class _TimeFormState extends State<_TimeForm> {
  TextEditingController daysController = TextEditingController();
  TextEditingController weeksController = TextEditingController();
  TextEditingController monthsController = TextEditingController();
  TextEditingController yearsController = TextEditingController();

  @override
  void dispose() {
    daysController.dispose();
    weeksController.dispose();
    monthsController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Establecer Tiempo"),
      content: Column(
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
            controller: weeksController,
            decoration: const InputDecoration(labelText: 'Semanas'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: daysController,
            decoration: const InputDecoration(labelText: 'Días'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              onPressed: () {
                double days = double.tryParse(daysController.text) ?? 0;
                double weeks = double.tryParse(weeksController.text) ?? 0;
                double months = double.tryParse(monthsController.text) ?? 0;
                double years = double.tryParse(yearsController.text) ?? 0;

                widget.setTime(years + days / 360 + weeks / 52 + months / 12);

                Navigator.of(context).pop();
              },
              child: const Text("Establecer"),
            ),
          ),
        ],
      ),
    );
  }
}
