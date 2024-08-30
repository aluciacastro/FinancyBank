abstract class CalculationSimpleDatasource {
  Future<double> capital({
    required double interest,
    required double rateInterest,
    required double time,
  });

  Future<double> capitalWithAmount({
    required double amount,
    required double rateInterest,
    required double time,
  });

  Future<double> finalAmount({
    required double capital,
    required double rateInterest,
    required double time,
  });

  Future<double> finalAmountWithInterst({
    required double capital,
    required double interest,
  });

  Future<double> rateInterest({
    required double interest,
    required double capital,
    required double time,
  });

  Future<double> rateInterestWithAmount({
    required double amount,
    required double capital,
    required double time,
  });

  Future<String> time({
    required double capital,
    required double interest,
    required double rateInterest,
  });

  Future<double> timeWithAmount({
    required double amount,
    required double capital,
    required double rateInterest,
  });

  Future<double> interest({
    required double capital,
    required double rateInterest,
    required double time,
  });

  Future<double> interestWithAmount({
    required double capital,
    required double amount,
  });
}
