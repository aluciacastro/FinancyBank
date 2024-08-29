import 'package:formz/formz.dart';

enum DataPercentageError { empty, notValid }

class DataPercentage extends FormzInput<double, DataPercentageError> {
  // Call super.pure to represent an unmodified form input.
  const DataPercentage.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const DataPercentage.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DataPercentageError.empty) {
      return 'Digite un valor valido';
    }
    if (displayError == DataPercentageError.notValid) {
      return 'Debe ser un valor entre 0% a 100%';
    }

    return null;
  }

  @override
  DataPercentageError? validator(double value) {
    final cleanValue = value.toString().trim();
    if (cleanValue.isEmpty) return DataPercentageError.empty;

    final isDouble = value / 100;

    if (isDouble > 1 || isDouble <= 0) return DataPercentageError.notValid;

    return null;
  }
}
