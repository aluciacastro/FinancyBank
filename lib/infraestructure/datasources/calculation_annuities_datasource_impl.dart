import 'dart:math';
import '../../domain/domain.dart';

class TimeResultAnnuity {
  final int years;
  final int months;
  final int weeks;
  final int days;

  TimeResultAnnuity({
    required this.years,
    required this.months,
    required this.weeks,
    required this.days,
  });
}

class CalculationAnnuitiesDatasourceImpl
    extends CalculationAnnuitiesDatasource {
  @override
  Future<double> calculateFinalValue({
    required double annuityRate,
    required double annuityValue,
    required double time,
  }) async {
    final newInterestRate = annuityRate / 100;
    final top =
        (pow((1 + newInterestRate), time).toDouble() - 1) / newInterestRate;
    final amount = annuityValue * top;
    return double.parse(amount.toStringAsFixed(2));
  }

  @override
  Future<double> calculateCurrentValue({
    required double annuityValue,
    required double annuityRate,
    required double time,
  }) async {
    final newInterestRate = annuityRate / 100;
    final bottom = (1 - pow(1 + newInterestRate, -time)) / newInterestRate;

    return double.parse((annuityValue * bottom).toStringAsFixed(2));
  }

  @override
  Future<double> calculateAnnuityValue({
    required double amount,
    required double annuityRate,
    required double time,
  }) async {
    final newInterestRate = annuityRate / 100;
    final top =
        (pow((1 + newInterestRate), time).toDouble() - 1) / newInterestRate;
    final annuity = amount / top;
    return double.parse(annuity.toStringAsFixed(2));
  }

  @override
  Future<double> calculateAnnuityRate({
    required double amount,
    required double annuityValue,
    required double time,
  }) async {
    final interest = ((amount / annuityValue) - 1) / time;
    return double.parse(interest.toStringAsFixed(2));
  }

  @override
  Future<String> calculateTime({
    required double amount,
    required double annuityValue,
    required double annuityRate,
  }) async {
    final newInterestRate = annuityRate / 100;
    // Calcular el tiempo en años
    double timeInYears = log(1 + (newInterestRate * amount / annuityValue)) /
        log(1 + newInterestRate);

    // Parte entera del tiempo en años
    int years = timeInYears.toInt();

    // Calcular el remanente para meses
    double remainingMonths = (timeInYears - years) * 12;

    // Parte entera del tiempo en meses
    int months = remainingMonths.toInt();

    // Calcular el remanente para días
    double remainingDays =
        (remainingMonths - months) * 30; // Promedio de días en un mes

    // Parte entera del tiempo en días
    int days = remainingDays.toInt();

    // Validar singular o plural para años
    String yearsText = years == 1 ? 'año' : 'años';

    // Validar singular o plural para meses
    String monthsText = months == 1 ? 'mes' : 'meses';

    // Validar singular o plural para días
    String daysText = days == 1 ? 'día' : 'días';

    // Crear la cadena de resultado
    String result = '$years $yearsText';

    // Agregar meses si es mayor que 0
    if (months > 0) {
      result += ', $months $monthsText';
    }

    // Agregar días si es mayor que 0
    if (days > 0) {
      result += ' y $days $daysText';
    }

    result += '.';

    return result;
  }
}
