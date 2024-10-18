import 'package:cesarpay/domain/repositories/inflation_repository.dart';

class InflationRepositoryImpl implements InflationRepository {
  @override
  double calculateInflation(double initialPrice, double finalPrice) {
    if (initialPrice <= 0 || finalPrice <= 0) {
      throw Exception('Los precios deben ser mayores que 0');
    }

    // Fórmula de inflación: ((P2 - P1) / P1) * 100
    return ((finalPrice - initialPrice) / initialPrice) * 100;
  }
}
