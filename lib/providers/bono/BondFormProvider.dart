import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bondProvider = StateNotifierProvider<BondNotifier, BondFormState>((ref) {
  return BondNotifier();
});

class BondFormState {
  final double nominalValue;
  final double couponRate;
  final double discountRate;
  final int periods;
  final double result;
  final bool isFormPosted;

  BondFormState({
    this.nominalValue = 0.0,
    this.couponRate = 0.0,
    this.discountRate = 0.0,
    this.periods = 0,
    this.result = 0.0,
    this.isFormPosted = false,
  });

  BondFormState copyWith({
    double? nominalValue,
    double? couponRate,
    double? discountRate,
    int? periods,
    double? result,
    bool? isFormPosted,
  }) {
    return BondFormState(
      nominalValue: nominalValue ?? this.nominalValue,
      couponRate: couponRate ?? this.couponRate,
      discountRate: discountRate ?? this.discountRate,
      periods: periods ?? this.periods,
      result: result ?? this.result,
      isFormPosted: isFormPosted ?? this.isFormPosted,
    );
  }
}

class BondNotifier extends StateNotifier<BondFormState> {
  BondNotifier() : super(BondFormState());

  void onNominalValueChanged(double value) {
    state = state.copyWith(nominalValue: value);
  }

  void onCouponRateChanged(double value) {
    state = state.copyWith(couponRate: value);
  }

  void onDiscountRateChanged(double value) {
    state = state.copyWith(discountRate: value);
  }

  void onPeriodsChanged(int value) {
    state = state.copyWith(periods: value);
  }

  void calculateBond() {
    // Fórmula básica para el cálculo del valor presente de un bono.
    double couponPayment = state.nominalValue * (state.couponRate / 100);
    double bondValue = 0.0;

    for (int t = 1; t <= state.periods; t++) {
  bondValue += couponPayment / pow((1 + (state.discountRate / 100)), t);
}

bondValue += state.nominalValue / pow((1 + (state.discountRate / 100)), state.periods);
    state = state.copyWith(result: bondValue, isFormPosted: true);
  }
}
