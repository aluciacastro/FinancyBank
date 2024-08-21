
class FormValidator {
  static String? validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Documento de Identificación es obligatorio';
    } else if (value.length < 8 || value.length > 10) {
      return 'El documento debe tener entre 8 y 10 dígitos';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'El documento solo debe contener números';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Contraseña es obligatorio';
    } else if (value.length != 6) {
      return 'La contraseña debe tener 4 dígitos';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'La contraseña solo debe contener números';
    }
    return null;
  }
}
