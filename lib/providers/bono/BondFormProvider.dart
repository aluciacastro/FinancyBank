import 'package:cesarpay/domain/repositories/BondRepository.dart';
import 'package:cesarpay/infraestructure/repositories/BondRepositoryImpl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




final bondRepositoryProvider = Provider<BondRepository>((ref) {
  return BondRepositoryImpl();
});


class BondFormState {
  final double faceValue;
  final double couponRate;
  final int yearsToMaturity;
  final double marketRate;
  final bool isFormPosted;
  final double result;

  BondFormState({
    required this.faceValue,
    required this.couponRate,
    required this.yearsToMaturity,
    required this.marketRate,
    required this.isFormPosted,
    required this.result,
  });

  BondFormState copyWith({
    double? faceValue,
    double? couponRate,
    int? yearsToMaturity,
    double? marketRate,
    bool? isFormPosted,
    double? result,
  }) {
    return BondFormState(
      faceValue: faceValue ?? this.faceValue,
      couponRate: couponRate ?? this.couponRate,
      yearsToMaturity: yearsToMaturity ?? this.yearsToMaturity,
      marketRate: marketRate ?? this.marketRate,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      result: result ?? this.result,
    );
  }
}


class BondFormNotifier extends StateNotifier<BondFormState> {
  final BondRepository _bondRepository;

  BondFormNotifier(this._bondRepository)
      : super(BondFormState(
            faceValue: 0.0,
            couponRate: 0.0,
            yearsToMaturity: 0,
            marketRate: 0.0,
            isFormPosted: false,
            result: 0.0));

  void onFaceValueChanged(double value) {
    state = state.copyWith(faceValue: value);
  }

  void onCouponRateChanged(double value) {
    state = state.copyWith(couponRate: value);
  }

  void onYearsToMaturityChanged(int value) {
    state = state.copyWith(yearsToMaturity: value);
  }

  void onMarketRateChanged(double value) {
    state = state.copyWith(marketRate: value);
  }

  void calculate() {
    double result = _bondRepository.calculateBondValue(
      faceValue: state.faceValue,
      couponRate: state.couponRate,
      yearsToMaturity: state.yearsToMaturity,
      marketRate: state.marketRate,
    );
    state = state.copyWith(result: result, isFormPosted: true);
  }
}

final bondFormProvider =
    StateNotifierProvider<BondFormNotifier, BondFormState>(
  (ref) => BondFormNotifier(ref.read(bondRepositoryProvider)),
);
