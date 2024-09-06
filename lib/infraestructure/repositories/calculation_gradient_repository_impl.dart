
import '../../domain/domain.dart';
import '../infraestructure.dart';

class CalculationGradientRepositoryImpl extends CalculationGradientRepository {
  final CalculationGradientDatasource datasource;

  CalculationGradientRepositoryImpl({CalculationGradientDatasource? datasource})
      : datasource = datasource ?? CalculationGradientDatasourceImpl();

  // GRADIENTE ARITMETICO

  // CRECIENTE
  @override
  Future<double> calculateGradientAIncreasingVP(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientAIncreasingVP(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  @override
  Future<double> calculateGradientAIncreasingVF(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientAIncreasingVF(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  // DECRECIENTE
  @override
  Future<double> calculateGradientADecreasingVP(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientADecreasingVP(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  @override
  Future<double> calculateGradientADecreasingVF(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientADecreasingVF(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  // GRADIENTE ARITMETICO

  // CRECIENTE
  @override
  Future<double> calculateGradientGIncreasingVP(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientGIncreasingVP(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  @override
  Future<double> calculateGradientGIncreasingVF(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientGIncreasingVF(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  // DECRECIENTE
  @override
  Future<double> calculateGradientGDecreasingVP(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientGDecreasingVP(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }

  @override
  Future<double> calculateGradientGDecreasingVF(
      {required double paymentSeries,
      required double variationG,
      required double interestRate,
      required double numPeriod}) {
    return datasource.calculateGradientGDecreasingVF(
      paymentSeries: paymentSeries,
      variationG: variationG,
      interestRate: interestRate,
      numPeriod: numPeriod,
    );
  }
}
