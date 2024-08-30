import '../../domain/domain.dart';
import '../infraestructure.dart';


class CalculationSimpleRepositoryImpl extends CalculationSimpleRepository {
  final CalculationSimpleDatasource datasource;

  CalculationSimpleRepositoryImpl({CalculationSimpleDatasource? datasource})
      : datasource = datasource ?? CalculationSimpleDatasourceImpl();

  @override
  Future<double> capital({
    required double interest,
    required double rateInterest,
    required double time,
  }) {
    return datasource.capital(
      interest: interest,
      rateInterest: rateInterest,
      time: time,
    );
  }

  @override
  Future<double> capitalWithAmount({
    required double amount,
    required double rateInterest,
    required double time,
  }) {
    return datasource.capitalWithAmount(
      amount: amount,
      rateInterest: rateInterest,
      time: time,
    );
  }

  @override
  Future<double> finalAmount({
    required double capital,
    required double rateInterest,
    required double time,
  }) {
    return datasource.finalAmount(
      capital: capital,
      rateInterest: rateInterest,
      time: time,
    );
  }

  @override
  Future<double> finalAmountWithInterst({
    required double capital,
    required double interest,
  }) {
    return datasource.finalAmountWithInterst(
      capital: capital,
      interest: interest,
    );
  }

  @override
  Future<double> interest({
    required double capital,
    required double rateInterest,
    required double time,
  }) {
    return datasource.interest(
      capital: capital,
      rateInterest: rateInterest,
      time: time,
    );
  }

  @override
  Future<double> interestWithAmount({
    required double capital,
    required double amount,
  }) {
    return datasource.interestWithAmount(
      capital: capital,
      amount: amount,
    );
  }

  @override
  Future<double> rateInterest({
    required double interest,
    required double capital,
    required double time,
  }) {
    return datasource.rateInterest(
      capital: capital,
      interest: interest,
      time: time,
    );
  }

  @override
  Future<double> rateInterestWithAmount({
    required double amount,
    required double capital,
    required double time,
  }) {
    return datasource.rateInterestWithAmount(
      capital: capital,
      amount: amount,
      time: time,
    );
  }

  @override
  Future<String> time(
      {required double capital,
      required double interest,
      required double rateInterest}) {
    return datasource.time(
      capital: capital,
      rateInterest: rateInterest,
      interest: interest,
    );
  }

  @override
  Future<double> timeWithAmount({
    required double amount,
    required double capital,
    required double rateInterest,
  }) {
    return datasource.timeWithAmount(
      capital: capital,
      rateInterest: rateInterest,
      amount: amount,
    );
  }
}
