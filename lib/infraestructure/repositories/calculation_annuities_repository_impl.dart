import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class CalculationAnnuitiesRepositoryImpl
    extends CalculationAnnuitiesRepository {
  final CalculationAnnuitiesDatasource datasource;

  CalculationAnnuitiesRepositoryImpl(
      {CalculationAnnuitiesDatasource? datasource})
      : datasource = datasource ?? CalculationAnnuitiesDatasourceImpl();

  @override
  Future<double> calculateFinalValue({
    required double annuityRate,
    required double annuityValue,
    required double time,
  }) {
    return datasource.calculateFinalValue(
      annuityRate: annuityRate,
      annuityValue: annuityValue,
      time: time,
    );
  }

  @override
  Future<double> calculateCurrentValue({
    required double annuityValue,
    required double annuityRate,
    required double time,
  }) {
    return datasource.calculateCurrentValue(
      annuityValue: annuityValue,
      annuityRate: annuityRate,
      time: time,
    );
  }

  @override
  Future<double> calculateAnnuityValue({
    required double amount,
    required double annuityRate,
    required double time,
  }) {
    return datasource.calculateAnnuityValue(
      amount: amount,
      annuityRate: annuityRate,
      time: time,
    );
  }

  @override
  Future<double> calculateAnnuityRate({
    required double amount,
    required double annuityValue,
    required double time,
  }) {
    return datasource.calculateAnnuityRate(
      amount: amount,
      annuityValue: annuityValue,
      time: time,
    );
  }

  @override
  Future<String> calculateTime({
    required double amount,
    required double annuityValue,
    required double annuityRate,
  }) {
    return datasource.calculateTime(
      amount: amount,
      annuityValue: annuityValue,
      annuityRate: annuityRate,
    );
  }
}
