abstract class CalculationGradientRepository {

  // GRADIENTE ARITMETICO
  
  Future<double> calculateGradientAIncreasingVP({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });

 Future<double> calculateGradientAIncreasingVF({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });
  Future<double> calculateGradientADecreasingVP({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });
  Future<double> calculateGradientADecreasingVF({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });

  // GRADIENTE GEOMETRICO

 Future<double> calculateGradientGIncreasingVP({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });

 Future<double> calculateGradientGIncreasingVF({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });
  Future<double> calculateGradientGDecreasingVP({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });
  Future<double> calculateGradientGDecreasingVF({
    required double paymentSeries,
    required double variationG,
    required double interestRate,
    required double numPeriod,
  });

}
