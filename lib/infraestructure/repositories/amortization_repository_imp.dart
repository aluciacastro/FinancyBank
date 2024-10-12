import 'dart:math';
import '../../domain/repositories/amortization_repository.dart';

class AmortizationRepositoryImpl implements AmortizationRepository {
  @override
  double calculateFrenchAmortization(double capital, double interestRate, int periods) {
    double monthlyRate = interestRate / 100 / 12;
    double amortization = (capital * monthlyRate) / (1 - (1 / (pow(1 + monthlyRate, periods))));
    return amortization;
  }

  @override
  double calculateGermanAmortization(double capital, double interestRate, int periods) {
    double amortization = capital / periods;
    return amortization;
  }

  @override
  double calculateAmericanAmortization(double capital, double interestRate, int periods) {
    double totalInterest = capital * (interestRate / 100) * periods;
    double totalAmount = capital + totalInterest;
    return totalAmount;
  }
}
