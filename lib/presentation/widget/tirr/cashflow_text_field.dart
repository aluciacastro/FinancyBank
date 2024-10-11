import 'package:flutter/material.dart';
import '../shared/custom_filled_button.dart';
import '../shared/custom_text_form_field.dart';

class CashFlowTextField extends StatelessWidget {

  final bool? enable;
  final String label;
  final String? text;
  final String? errorMessage;
  final void Function(List<double>) onPressed;

  const CashFlowTextField({
    super.key,
    this.enable,
    this.label = "Flujos de caja",
    this.text,
    this.errorMessage,
    required this.onPressed,
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
            context: context, builder: (context) => _CashForm(onPressed),
          );
        },
        icon: const Icon(Icons.add_box_outlined),
      ),
      errorMessage: errorMessage,
    );
  }
}

class _CashForm extends StatefulWidget {
  final void Function(List<double>) onPressed;

  const _CashForm(this.onPressed);

  @override
  State<_CashForm> createState() => _CashFormState();
}

class _CashFormState extends State<_CashForm> {
  TextEditingController cashflowNumber = TextEditingController();

  @override
  void dispose() {
    cashflowNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cantidad flujos de caja"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: cashflowNumber,
            decoration: const InputDecoration(labelText: 'Cantidad'),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              onPressed: (){
                if(cashflowNumber.text.isEmpty) return;

                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => _DataCashflow(
                    widget.onPressed,
                    cashflowNumber: int.tryParse(cashflowNumber.text) ?? 0
                  )
                );
              },
              child: const Text("Aceptar"),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCashflow extends StatefulWidget {
  final int cashflowNumber;
  final void Function(List<double>) onPressed;

  const _DataCashflow(
    this.onPressed,
    {required this.cashflowNumber}
  );

  @override
  State<_DataCashflow> createState() => _DataCashflowState();
}

class _DataCashflowState extends State<_DataCashflow> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.cashflowNumber,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {controller.dispose();}
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Valores"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(widget.cashflowNumber, (index) {
              return TextFormField(
                controller: controllers[index],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Flujo ${index + 1}"),
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onPressed(controllers.map((controller) {
                    return double.tryParse(controller.text) ?? 0;
                  }).toList());
                },
                child: const Text("Aceptar"),
              ),
            )
          ],
        ),
      )
    );
  }
}