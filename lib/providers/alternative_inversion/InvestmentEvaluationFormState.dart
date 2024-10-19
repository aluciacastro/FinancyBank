import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class InvestmentState {
  final List<double> cashFlows;
  final double discountRate;
  final bool isFormPosted;
  final double npvResult;

  InvestmentState({
    required this.cashFlows,
    required this.discountRate,
    required this.isFormPosted,
    required this.npvResult,
  });

  InvestmentState copyWith({
    List<double>? cashFlows,
    double? discountRate,
    bool? isFormPosted,
    double? npvResult,
  }) {
    return InvestmentState(
      cashFlows: cashFlows ?? this.cashFlows,
      discountRate: discountRate ?? this.discountRate,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      npvResult: npvResult ?? this.npvResult,
    );
  }
}

class InvestmentNotifier extends StateNotifier<InvestmentState> {
  InvestmentNotifier()
      : super(InvestmentState(
          cashFlows: [],
          discountRate: 0,
          isFormPosted: false,
          npvResult: 0,
        ));

  void onCashFlowChanged(int index, double value) {
    final updatedCashFlows = List<double>.from(state.cashFlows);
    if (index < updatedCashFlows.length) {
      updatedCashFlows[index] = value;
    } else {
      updatedCashFlows.add(value);
    }
    state = state.copyWith(cashFlows: updatedCashFlows);
  }

  void onDiscountRateChanged(double value) {
    state = state.copyWith(discountRate: value);
  }

  void calculateNPV() {
    double npv = 0;
    for (int t = 0; t < state.cashFlows.length; t++) {
      npv += state.cashFlows[t] / pow((1 + (state.discountRate / 100)), t + 1);
    }

    state = state.copyWith(npvResult: npv, isFormPosted: true);
  }
}

final investmentProvider = StateNotifierProvider<InvestmentNotifier, InvestmentState>((ref) {
  return InvestmentNotifier();
});
