abstract class CalculationAnnuitiesRepository {
  Future<double> calculateFinalValue({
    required double annuityValue,
    required double annuityRate,
    required double time,
  });

  Future<double> calculateCurrentValue({
    required double annuityValue,
    required double annuityRate,
    required double time,
  });

  Future<double> calculateAnnuityValue({
    required double amount,
    required double annuityRate,
    required double time,
  });

  Future<double> calculateAnnuityRate({
    required double amount,
    required double annuityValue,
    required double time,
  });

  Future<String> calculateTime({
    required double amount,
    required double annuityValue,
    required double annuityRate,
  });
}
