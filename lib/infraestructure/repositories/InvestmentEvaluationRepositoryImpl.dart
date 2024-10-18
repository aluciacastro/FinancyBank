import 'dart:math';
import 'package:cesarpay/domain/repositories/InvestmentEvaluationRepository.dart';

class InvestmentEvaluationRepositoryImpl implements InvestmentEvaluationRepository {
  @override
  double calculateNPV(double initialInvestment, List<double> cashFlows, double discountRate) {
    double npv = -initialInvestment;

    for (int t = 0; t < cashFlows.length; t++) {
      npv += cashFlows[t] / pow(1 + discountRate, t + 1);
    }

    return npv;
  }
}
