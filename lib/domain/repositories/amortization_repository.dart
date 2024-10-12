abstract class AmortizationRepository {
  double calculateFrenchAmortization(double capital, double interestRate, int periods);
  double calculateGermanAmortization(double capital, double interestRate, int periods);
  double calculateAmericanAmortization(double capital, double interestRate, int periods);
}
