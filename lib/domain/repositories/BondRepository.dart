abstract class BondRepository {
  double calculateBondValue({
    required double faceValue,
    required double couponRate,
    required int yearsToMaturity,
    required double marketRate,
  });
}
