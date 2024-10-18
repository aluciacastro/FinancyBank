import 'package:cesarpay/domain/repositories/InvestmentEvaluationRepository.dart';
import 'package:cesarpay/infraestructure/repositories/InvestmentEvaluationRepositoryImpl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvestmentEvaluationFormState {
  final double initialInvestment;
  final List<double> cashFlows;
  final double discountRate;
  final bool isFormPosted;
  final double result;

  InvestmentEvaluationFormState({
    required this.initialInvestment,
    required this.cashFlows,
    required this.discountRate,
    required this.isFormPosted,
    required this.result,
  });

  InvestmentEvaluationFormState copyWith({
    double? initialInvestment,
    List<double>? cashFlows,
    double? discountRate,
    bool? isFormPosted,
    double? result,
  }) {
    return InvestmentEvaluationFormState(
      initialInvestment: initialInvestment ?? this.initialInvestment,
      cashFlows: cashFlows ?? this.cashFlows,
      discountRate: discountRate ?? this.discountRate,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      result: result ?? this.result,
    );
  }
}
class InvestmentEvaluationFormNotifier extends StateNotifier<InvestmentEvaluationFormState> {
  final InvestmentEvaluationRepository investmentRepository;

  InvestmentEvaluationFormNotifier(this.investmentRepository)
      : super(InvestmentEvaluationFormState(
          initialInvestment: 0,
          cashFlows: [],
          discountRate: 0,
          isFormPosted: false,
          result: 0,
        ));

  void onInitialInvestmentChanged(double value) {
    state = state.copyWith(initialInvestment: value);
  }

  void onCashFlowsChanged(List<double> values) {
    state = state.copyWith(cashFlows: values);
  }

  void onDiscountRateChanged(double value) {
    state = state.copyWith(discountRate: value);
  }

  void calculateNPV() {
    final result = investmentRepository.calculateNPV(
      state.initialInvestment,
      state.cashFlows,
      state.discountRate,
    );

    state = state.copyWith(result: result, isFormPosted: true);
  }
}

final investmentEvaluationFormProvider =
    StateNotifierProvider<InvestmentEvaluationFormNotifier, InvestmentEvaluationFormState>((ref) {
  final investmentRepository = ref.watch(investmentRepositoryProvider);
  return InvestmentEvaluationFormNotifier(investmentRepository);
});

final investmentRepositoryProvider = Provider<InvestmentEvaluationRepository>((ref) {
  return InvestmentEvaluationRepositoryImpl();
});
