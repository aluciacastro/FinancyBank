import 'package:flutter_riverpod/flutter_riverpod.dart';


class InflationState {
  final double initialPrice;
  final double finalPrice;
  final bool isFormPosted;
  final double inflationResult;

  InflationState({
    required this.initialPrice,
    required this.finalPrice,
    required this.isFormPosted,
    required this.inflationResult,
  });

  InflationState copyWith({
    double? initialPrice,
    double? finalPrice,
    bool? isFormPosted,
    double? inflationResult,
  }) {
    return InflationState(
      initialPrice: initialPrice ?? this.initialPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      inflationResult: inflationResult ?? this.inflationResult,
    );
  }
}

class InflationNotifier extends StateNotifier<InflationState> {
  InflationNotifier()
      : super(InflationState(
          initialPrice: 0,
          finalPrice: 0,
          isFormPosted: false,
          inflationResult: 0,
        ));

  void onInitialPriceChanged(double value) {
    state = state.copyWith(initialPrice: value);
  }

  void onFinalPriceChanged(double value) {
    state = state.copyWith(finalPrice: value);
  }

  void calculateInflation() {
    if (state.initialPrice > 0 && state.finalPrice > 0) {
      final inflation = ((state.finalPrice - state.initialPrice) / state.initialPrice) * 100;
      state = state.copyWith(inflationResult: inflation, isFormPosted: true);
    }
  }
}

final inflationProvider = StateNotifierProvider<InflationNotifier, InflationState>((ref) {
  return InflationNotifier();
});
