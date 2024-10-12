import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/uvr_repository.dart';
import '../../infraestructure/repositories/uvr_state.dart';

class UVRNotifier extends StateNotifier<UVRFormState> {
  final UVRRepository _repository;

  UVRNotifier(Ref ref)
      : _repository = UVRRepositoryImpl(),
        super(UVRFormState());

  void onCapitalChanged(double capital) {
    state = state.copyWith(capital: capital);
  }

  void onInterestRateChanged(double rate) {
    state = state.copyWith(interestRate: rate);
  }

  void onPeriodsChanged(int periods) {
    state = state.copyWith(periods: periods);
  }

  void calculateUVR() {
    final result = _repository.calculateUVR(
      state.capital,
      state.interestRate,
      state.periods,
    );
    state = state.copyWith(result: result.toString(), isFormPosted: true);
  }
}


final uvrProvider = StateNotifierProvider<UVRNotifier, UVRFormState>((ref) {
  return UVRNotifier(ref);
});
