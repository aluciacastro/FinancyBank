import 'package:intl/intl.dart';

class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Nombre y Apellido es obligatorio';
    } else if (value.length > 20) {
      return 'El nombre no debe superar los 20 caracteres';
    }
    return null;
  }

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

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Fecha de Nacimiento es obligatorio';
    } else {
      DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(value);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - selectedDate.year;
      if (selectedDate.isAfter(currentDate.subtract(Duration(days: age * 365)))) {
        age--;
      }
      if (age < 18) {
        return 'Debe ser mayor de 18 años';
      }
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Correo Electrónico es obligatorio';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Contraseña es obligatorio';
    } else if (value.length != 6) {
      return 'La contraseña debe tener 6 dígitos';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'La contraseña solo debe contener números';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'El campo Confirmar Contraseña es obligatorio';
    } else if (value.length != 6) {
      return 'La contraseña debe tener 6 dígitos';
    } else if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  static String? validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Código de Verificación es obligatorio';
    } else if (value.length != 6) {
      return 'El código de verificación debe tener 6 dígitos';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'El código de verificación solo debe contener números';
    }
    return null;
  }
}
