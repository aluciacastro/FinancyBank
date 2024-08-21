class FormValidator {
  

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Correo Electrónico es obligatorio';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }
}
