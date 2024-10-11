abstract class CalculationTirRepository {
  Future<double> calculateTIR({
    required double investment,
    required List<double> cashflow,
  });

  Future<double> calculateVAN({
    required double investment,
    required double tir,
    required List<double> cashflow,
  });

  Future<double> calculateInvestment({
    required double van,
    required double tir,
    required List<double> cashflow,
  });
}
