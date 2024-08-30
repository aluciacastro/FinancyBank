import '../../domain/domain.dart';

class TimeResult {
  final int years;
  final int months;
  final int weeks;
  final int days;

  TimeResult({
    required this.years,
    required this.months,
    required this.weeks,
    required this.days,
  });
}

class CalculationSimpleDatasourceImpl extends CalculationSimpleDatasource {
  //Calcular Capital, tasa de interes se recibe como % y el tiempo en Años.
  @override
  Future<double> capital({
    required double interest,
    required double rateInterest,
    required double time,
  }) async {
    double result = (interest / ((rateInterest / 100) * time));
    return double.parse(result.toStringAsFixed(2));
  }

  @override
  Future<double> capitalWithAmount({
    required double amount,
    required double rateInterest,
    required double time,
  }) async {
    return (amount / (1 + ((rateInterest / 100) * time)));
  }

  //Calcular Monto, tasa de interes se recibe como % y el tiempo en Años.
  @override
  Future<double> finalAmount(
      {required double capital,
      required double rateInterest,
      required double time}) async {
    double result = capital * (1 + (rateInterest / 100) * time);
    return double.parse(result.toStringAsFixed(2));
  }

  @override
  Future<double> finalAmountWithInterst({
    required double capital,
    required double interest,
  }) async {
    return capital + interest;
  }

  //Calcular Interes, tasa de interes se recibe como % y el tiempo en Años.
  @override
  Future<double> interest({
    required double capital,
    required double rateInterest,
    required double time,
  }) async {
    double result = capital * (rateInterest / 100) * time;
    return double.parse(result.toStringAsFixed(2));
  }

  @override
  Future<double> interestWithAmount({
    required double capital,
    required double amount,
  }) async {
    return amount - capital;
  }

  //Calcular Tasa de Interest, tiempo se recibe en Años.
  @override
  Future<double> rateInterest({
    required double capital,
    required double interest,
    required double time,
  }) async {
    double result = (interest / (capital * time)) * 100;
    return double.parse(result.toStringAsFixed(2));
  }

  @override
  Future<double> rateInterestWithAmount({
    required double capital,
    required double amount,
    required double time,
  }) async {
    return ((amount - capital) / (capital * time));
  }

  @override
  Future<String> time({
    required double capital,
    required double interest,
    required double rateInterest,
  }) async {
    // Calcular el tiempo en años
    double timeInYears = interest / (capital * (rateInterest / 100));

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

  @override
  Future<double> timeWithAmount({
    required double capital,
    required double amount,
    required double rateInterest,
  }) async {
    return ((amount - capital) / (capital * (rateInterest / 100)));
  }
}
