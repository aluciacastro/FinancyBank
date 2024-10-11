import 'dart:math';
import 'package:cesarpay/domain/datasources/datasources.dart';
import 'package:finance_updated/finance_updated.dart';

class CalCulationTirDatasourceImpl extends CalculationTirDatasource {

  final Finance finance = Finance();

  @override
  Future<double> calculateTIR({
    required double investment,
    required List<double> cashflow,
  }) async {
    cashflow = [-investment, ...cashflow];
    return finance.irr(values: cashflow).toDouble() * 100;
  }

  @override
  Future<double> calculateVAN({
    required double investment,
    required double tir,
    required List<double> cashflow,
  }) async {
    cashflow = [-investment, ...cashflow];
    return finance.npv(rate: tir/100, values: cashflow).toDouble();
  }

  @override
  Future<double> calculateinvestment({
    required double van,
    required double tir,
    required List<double> cashflow,
  }) async {
    double sum = 0;
    final doubleTir = tir / 100;

    for(int i = 0; i < cashflow.length; i++) {
      sum += cashflow[i] / pow((1 + doubleTir), (i + 1));
    }
    
    return sum - van;
  }
}
