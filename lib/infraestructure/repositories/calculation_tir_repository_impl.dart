
import 'package:cesarpay/domain/domain.dart';
import 'package:cesarpay/infraestructure/infraestructure.dart';

class CalculationTirRepositoryImpl extends CalculationTirRepository {
  final CalculationTirDatasource datasource;

  CalculationTirRepositoryImpl({CalculationTirDatasource? datasource})
      : datasource = datasource ?? CalCulationTirDatasourceImpl();

  @override
  Future<double> calculateTIR({
    required double investment,
    required List<double> cashflow,
  }) {
    return datasource.calculateTIR(investment: investment, cashflow: cashflow);
  }

  @override
  Future<double> calculateVAN({
    required double investment,
    required double tir,
    required List<double> cashflow,
  }) {
    return datasource.calculateVAN(investment: investment, tir: tir, cashflow: cashflow);
  }

  @override
  Future<double> calculateInvestment({
    required double van,
    required double tir,
    required List<double> cashflow,
  }) {
    return datasource.calculateinvestment(van: van, tir: tir, cashflow: cashflow);
  }
}
