import 'package:formz/formz.dart';

enum DataNumberError { empty, notNumber }

class DataNumber extends FormzInput<double, DataNumberError> {

  // Call super.pure to represent an unmodified form input.
  const DataNumber.pure() : super.pure(0.0);

  // Call super.dirty to represent a modified form input.
  const DataNumber.dirty( super.value ) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == DataNumberError.empty ) return 'Digite el valor';
    if ( displayError == DataNumberError.notNumber ) return 'Debe ser un número';

    return null;
  }

  @override
  DataNumberError? validator(double value) {

    final cleanValue = value.toString().trim();
    if (cleanValue.isEmpty || value == 0) return DataNumberError.empty;

    final isDouble = double.tryParse(value.toString());
    if (isDouble == null) return DataNumberError.notNumber;

    return null;
  }
}
