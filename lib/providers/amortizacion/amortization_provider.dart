import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/amortization_repository.dart';
import '../../infraestructure/repositories/amortization_repository_imp.dart';

final amortizationProvider = StateNotifierProvider<AmortizationNotifier, AmortizationFormState>((ref) {
  return AmortizationNotifier(ref);
});

class AmortizationFormState {
  final double capital;
  final double interestRate;
  final int periods;
  final String amortizationType;
  final String result;
  final bool isFormPosted;

  AmortizationFormState({
    this.capital = 0,
    this.interestRate = 0,
    this.periods = 0,
    this.amortizationType = 'Francesa',
    this.result = '',
    this.isFormPosted = false,
  });

  AmortizationFormState copyWith({
    double? capital,
    double? interestRate,
    int? periods,
    String? amortizationType,
    String? result,
    bool? isFormPosted,
  }) {
    return AmortizationFormState(
      capital: capital ?? this.capital,
      interestRate: interestRate ?? this.interestRate,
      periods: periods ?? this.periods,
      amortizationType: amortizationType ?? this.amortizationType,
      result: result ?? this.result,
      isFormPosted: isFormPosted ?? this.isFormPosted,
    );
  }
}

class AmortizationNotifier extends StateNotifier<AmortizationFormState> {
  final AmortizationRepository _repository;

  AmortizationNotifier(Ref ref)
      : _repository = AmortizationRepositoryImpl(),
        super(AmortizationFormState());

  void onCapitalChanged(double capital) {
    state = state.copyWith(capital: capital);
  }

  void onInterestRateChanged(double rate) {
    state = state.copyWith(interestRate: rate);
  }

  void onPeriodsChanged(int periods) {
    state = state.copyWith(periods: periods);
  }

  void onAmortizationTypeChanged(String type) {
    state = state.copyWith(amortizationType: type);
  }

  void calculateAmortization() {
    double result;
    if (state.amortizationType == 'Francesa') {
      result = _repository.calculateFrenchAmortization(state.capital, state.interestRate, state.periods);
    } else if (state.amortizationType == 'Alemana') {
      result = _repository.calculateGermanAmortization(state.capital, state.interestRate, state.periods);
    } else {
      result = _repository.calculateAmericanAmortization(state.capital, state.interestRate, state.periods);
    }
    state = state.copyWith(result: result.toString(), isFormPosted: true);
  }
}
