import 'dart:math';
import '../../domain/domain.dart';

class CalculationCompoundDatasourceImpl extends CalculationCompoundDatasource {
  @override
  Future<double> calculateAmountComp(
      {required double capital,
      required double capInterestRate,
      required TypeInterestRate typeInterestRate,
      required CapitalizationPeriod capitalizationPeriod,
      required double time}) async {
    // Conversion de: Tipo de tasa de interes y Capitalizacion

    double conversionFactorFraction =
        formulaTipoInteres(typeInterestRate, capitalizationPeriod);

    double interes = capInterestRate / 100;

    double effectiveInterestRate = interes * conversionFactorFraction;

    double amount = capital * (pow(1 + effectiveInterestRate, (time)));
    double result = double.parse(amount.toStringAsFixed(4));
    return result;
  }

  @override
  Future<double> calculateCapitalComp(
      {required double amount,
      required double capInterestRate,
      required TypeInterestRate typeInterestRate,
      required CapitalizationPeriod capitalizationPeriod,
      required double time}) async {
    // Conversion de: Tipo de tasa de interes y Capotalizacion

    double conversionFactorFraction =
        formulaTipoInteres(typeInterestRate, capitalizationPeriod);

    double interes = capInterestRate / 100;

    double effectiveInterestRate = interes * conversionFactorFraction;

    double capitalResult =
        amount / (pow(1 + effectiveInterestRate.toDouble(), (time)));
    final result = double.parse(capitalResult.toStringAsFixed(4));
    return result;
  }

  @override
  Future<double> calculateInterestRate(
      {required double amount,
      required double capital,
      required TypeInterestRate typeInterestRate,
      required CapitalizationPeriod capitalizationPeriod,
      required double time}) async {
    // Conversion de: Tipo de tasa de interes y Capotalizacion

    double conversionFactorFraction =
        formulaTipoInteres(typeInterestRate, capitalizationPeriod);

    // se va provar sin que el resultado de esta operacion se multiplique por capitalResult
    // ignore: unused_local_variable
    double effectiveInterestRate =
        (conversionFactorFraction) / conversionFactorFraction;

    double capitalResult = ((pow(amount / capital, (1 / time)) - 1).toDouble());
    final result = double.parse(capitalResult.toStringAsFixed(4));
    return result;
  }

  @override
  Future<double> calculateInterestRate2(
      {required double amount, required double capital}) async {
    double capitalResult = amount - capital;
    final result = double.parse(capitalResult.toStringAsFixed(4));
    return result;
  }

  @override
  Future<double> calculateTimeComp(
      {required double amount,
      required double capital,
      required double capInterestRate,
      required TypeInterestRate typeInterestRate,
      required CapitalizationPeriod capitalizationPeriod}) async {
    // Conversion de: Tipo de tasa de interes y Capotalizacion

    double conversionFactorFraction =
        formulaTipoInteres(typeInterestRate, capitalizationPeriod);

    // se va provar sin que el resultado de esta operacion se multiplique por capitalResult
    // ignore: unused_local_variable
    double effectiveInterestRate =
        (conversionFactorFraction) / conversionFactorFraction;

    double timeResult = (log(amount) - log(capital) / log(1 + capInterestRate));
    final result = double.parse(timeResult.toStringAsFixed(4));
    return result;
  }
}
