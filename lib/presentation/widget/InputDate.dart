import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller; // Añadido

  const DatePickerField({
    required this.label,
    required this.icon,
    this.validator,
    this.controller, // Añadido
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Añadido
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon),
      ),
      validator: widget.validator,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          setState(() {
            widget.controller?.text = formattedDate; // Añadido
          });
        }
      },
    );
  }
}
