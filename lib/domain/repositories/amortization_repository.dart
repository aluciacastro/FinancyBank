class AmortizationPayment {
  final double cuota;
  final double interes;
  final double amortizacion;

  AmortizationPayment({
    required this.cuota,
    required this.interes,
    required this.amortizacion,
  });
}

abstract class AmortizationRepository {
  List<AmortizationPayment> calculateFrenchAmortization(double capital, double interestRate, int periods);
  List<AmortizationPayment> calculateGermanAmortization(double capital, double interestRate, int periods);
  List<AmortizationPayment> calculateAmericanAmortization(double capital, double interestRate, int periods);
}
