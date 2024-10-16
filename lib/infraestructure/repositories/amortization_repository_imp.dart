import 'dart:math';
import '../../domain/repositories/amortization_repository.dart';

class AmortizationRepositoryImpl implements AmortizationRepository {
  @override
  List<AmortizationPayment> calculateFrenchAmortization(double capital, double interestRate, int periods) {
    double rate = interestRate / 100 / 12; // Tasa mensual
    double cuota = double.parse((capital * rate / (1 - pow(1 + rate, -periods))).toStringAsFixed(2));

    List<AmortizationPayment> pagos = [];
    double saldo = capital;

    for (int i = 0; i < periods; i++) {
      double interes = double.parse((saldo * rate).toStringAsFixed(2));
      double amortizacionPrincipal = double.parse((cuota - interes).toStringAsFixed(2));
      saldo = double.parse((saldo - amortizacionPrincipal).toStringAsFixed(2));

      pagos.add(AmortizationPayment(
        cuota: cuota,
        interes: interes,
        amortizacion: amortizacionPrincipal,
      ));
    }

    return pagos;
  }

  @override
  List<AmortizationPayment> calculateGermanAmortization(double capital, double interestRate, int periods) {
    double rate = interestRate / 100 / 12;
    double amortizacionConstante = double.parse((capital / periods).toStringAsFixed(2));

    List<AmortizationPayment> pagos = [];
    double saldo = capital;

    for (int i = 0; i < periods; i++) {
      double interes = double.parse((saldo * rate).toStringAsFixed(2));
      double cuota = double.parse((amortizacionConstante + interes).toStringAsFixed(2));
      saldo = double.parse((saldo - amortizacionConstante).toStringAsFixed(2));

      pagos.add(AmortizationPayment(
        cuota: cuota,
        interes: interes,
        amortizacion: amortizacionConstante,
      ));
    }

    return pagos;
  }

  @override
  List<AmortizationPayment> calculateAmericanAmortization(double capital, double interestRate, int periods) {
    double rate = interestRate / 100 ; // Tasa anual

    List<AmortizationPayment> pagos = [];

    // Pago de intereses mensuales
    for (int i = 0; i < periods - 1; i++) {
      double interes = double.parse((capital * rate).toStringAsFixed(2));
      pagos.add(AmortizationPayment(
        cuota: interes,
        interes: interes,
        amortizacion: 0,
      ));
    }

    // Último pago: capital + interés
    double cuotaFinal = double.parse((capital + (capital * rate)).toStringAsFixed(2));
    pagos.add(AmortizationPayment(
      cuota: cuotaFinal,
      interes: double.parse((capital * rate).toStringAsFixed(2)),
      amortizacion: capital,
    ));

    return pagos;
  }
}

