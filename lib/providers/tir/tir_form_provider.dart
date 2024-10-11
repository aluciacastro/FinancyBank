
import 'package:cesarpay/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'tir_repository_provider.dart';


final tirFormProvider = StateNotifierProvider.autoDispose<TirFormNotifier, TirFormState>(
  (ref) {
    final tirRepository = ref.watch(tirRepositoryProvider);
    return TirFormNotifier(repository: tirRepository);
  }
);

enum TirVariable {none, tir, van, investment}

class TirFormState {
  final menuOptions = const <TirVariable, String>{
    TirVariable.tir: "TIR",
    TirVariable.van: "VAN",
    TirVariable.investment: "Inversión",
  };

  final bool isFormPosted;
  final bool isValid;
  final TirVariable variable;
  final DataNumber van;
  final DataNumber investment;
  final List<DataNumber> cashflow;
  final DataPercentage tir;
  final double result;

  TirFormState({
    this.isFormPosted = false,
    this.isValid = false,
    this.variable = TirVariable.none,
    this.van = const DataNumber.pure(),
    this.investment = const DataNumber.pure(),
    this.cashflow = const <DataNumber>[],
    this.tir = const DataPercentage.pure(),
    this.result = 0,
  });

  TirFormState copyWith({
    bool? isFormPosted,
    bool? isValid,
    TirVariable? variable,
    DataNumber? van,
    DataNumber? investment,
    List<DataNumber>? cashflow,
    DataPercentage? tir,
    double? result,
  }) => TirFormState(
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    variable: variable ?? this.variable,
    van: van ?? this.van,
    investment: investment ?? this.investment,
    cashflow: cashflow ?? this.cashflow,
    tir: tir ?? this.tir,
    result: result ?? this.result,
  );

}

class TirFormNotifier extends StateNotifier<TirFormState> {
  CalculationTirRepositoryImpl repository;

  TirFormNotifier({
    required this.repository,
  }) : super(TirFormState());

  void onTirVaraibleChanged(TirVariable value) {
    state = state.copyWith(variable: value);
  }

  void onVanChanged(double value) {
    state = state.copyWith(
      van: DataNumber.dirty(value),
    );
  }

  void onInvestmentChanged(double value) {
    state = state.copyWith(
      investment: DataNumber.dirty(value),
    );
  }

  void onTirChanged(double value) {
    state = state.copyWith(
      tir: DataPercentage.dirty(value)
    );
  }

  void onCashFlowChanged(List<double> value) {
    List<DataNumber> cashflowValues = value.map(
      (cashflow) => DataNumber.dirty(cashflow)
    ).toList();
    
    state = state.copyWith(
      cashflow: cashflowValues,
    );
  }

  void calculate() async {
    _touchEveryField();

    if (!state.isValid) return;

    double result = 0;
    final cashFlowValues = state.cashflow.map((cf) => cf.value).toList();
    switch (state.variable) {
      case TirVariable.van:
        result = await repository.calculateVAN(
          tir: state.tir.value,
          investment: state.investment.value,
          cashflow: cashFlowValues,
        );
        break;

      case TirVariable.tir:
        result = await repository.calculateTIR(
          investment: state.investment.value,
          cashflow: cashFlowValues,
        );
        break;

      case TirVariable.investment:
        result = await repository.calculateInvestment(
          van: state.van.value,
          tir: state.tir.value,
          cashflow: cashFlowValues,
        );
        break;

      default:
        break;
    }
    state = state.copyWith(result: result);
  }

  void _touchEveryField() {
    state = state.copyWith(
      isFormPosted: true,
      van: DataNumber.dirty(state.van.value),
      tir: DataPercentage.dirty(state.tir.value),
      investment: DataNumber.dirty(state.investment.value),
      cashflow: state.cashflow,

      isValid:Formz.validate([
        if(state.variable != TirVariable.tir) state.tir,
        if(state.variable != TirVariable.van && 
        state.variable != TirVariable.tir) state.van,
        if(state.variable != TirVariable.investment) state.investment,
      ]),
    );
  }
}