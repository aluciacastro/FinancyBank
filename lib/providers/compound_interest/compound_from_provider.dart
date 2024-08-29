import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../../infraestructure/infraestructure.dart';
import '../providers.dart';
import '../../../domain/entities/capitalization.dart';

final compoundFormProvider =
    StateNotifierProvider.autoDispose<CompoundFormNotifier, CompoundFromState>(
        (ref) {
  final compoundInterestRepository = ref.watch(compoundRepositorytProvider);

  return CompoundFormNotifier(
    repository: compoundInterestRepository,
  );
});

enum CompoundVariable {
  none,
  amount,
  capital,
  interestRate,
  interestRate2,
  time
}

class CompoundFromState {
  final CapitalizationPeriod capitalizationPeriod;
  final TypeInterestRate typeInterestRate;

  final menuOptions = const <CompoundVariable, String>{
    CompoundVariable.amount: "Monto",
    CompoundVariable.capital: "Capital",
    CompoundVariable.interestRate: "Tasa de Interés (1)",
    CompoundVariable.interestRate2: "Tasa de Interés (2)",
    CompoundVariable.time: "Tiempo",
  };
  final menuOptionsCap = const <CapitalizationPeriod, String>{
    CapitalizationPeriod.diario: "Diario",
    CapitalizationPeriod.mensual: "Mensual",
    CapitalizationPeriod.bimestral: "Bimestral",
    CapitalizationPeriod.trimestral: "Trimestral",
    CapitalizationPeriod.semestral: "Semestral",
    CapitalizationPeriod.anual: "Anual",
  };
  // Tipo de tasa de interes
  final menuOptionsTypeInterest = const <TypeInterestRate, String>{
    TypeInterestRate.diario: "Diario",
    TypeInterestRate.mensual: "Mensual",
    TypeInterestRate.bimestral: "Bimestral",
    TypeInterestRate.trimestral: "Trimestral",
    TypeInterestRate.semestral: "Semestral",
    TypeInterestRate.anual: "Anual",
  };

  final bool isFormPosted;
  final bool isValid;
  final CompoundVariable variable;
  final DataNumber amount;
  final DataNumber capital;
  final DataNumber capInterestRate;
  final DataNumber time;
  final double result;

  CompoundFromState({
    this.isFormPosted = false,
    this.isValid = false,
    this.variable = CompoundVariable.none,
    this.amount = const DataNumber.pure(),
    this.capital = const DataNumber.pure(),
    this.capInterestRate = const DataNumber.pure(),
    this.typeInterestRate = TypeInterestRate.none,
    this.capitalizationPeriod = CapitalizationPeriod.none,
    this.time = const DataNumber.pure(),
    this.result = 0,
  });

  CompoundFromState copyWith({
    bool? isFormPosted,
    bool? isValid,
    CompoundVariable? variable,
    DataNumber? amount,
    DataNumber? capital,
    DataNumber? capInterestRate,
    TypeInterestRate? typeInterestRate,
    CapitalizationPeriod? capitalizationPeriod,
    DataNumber? time,
    double? result,
  }) =>
      CompoundFromState(
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        variable: variable ?? this.variable,
        amount: amount ?? this.amount,
        capital: capital ?? this.capital,
        capInterestRate: capInterestRate ?? this.capInterestRate,
        typeInterestRate: typeInterestRate ?? this.typeInterestRate,
        capitalizationPeriod: capitalizationPeriod ?? this.capitalizationPeriod,
        time: time ?? this.time,
        result: result ?? this.result,
      );
}

class CompoundFormNotifier extends StateNotifier<CompoundFromState> {
  CalculationCompoundRepositoryImpl repository;

  CompoundFormNotifier({
    required this.repository,
  }) : super(CompoundFromState());

  void onOptionsCompoundChanged(CompoundVariable value) {
    state = state.copyWith(variable: value);
  }

  void onAmountChanged(double value) {
    state = state.copyWith(
      amount: DataNumber.dirty(value),
    );
  }

  void onCapitalChanged(double value) {
    state = state.copyWith(
      capital: DataNumber.dirty(value),
    );
  }

  void onInterestRateChanged(double value) {
    state = state.copyWith(
      capInterestRate: DataNumber.dirty(value),
    );
  }

  void onInterestRate2Changed(double value) {
    state = state.copyWith(
      capInterestRate: DataNumber.dirty(value),
    );
  }

  // Tipo de tasa de interes
  void onOptionsTypeInterestRateChanged(TypeInterestRate value) {
    state = state.copyWith(typeInterestRate: value);
  }

  // capitalizacion
  void onOptionsCapitalizationChanged(CapitalizationPeriod value) {
    state = state.copyWith(capitalizationPeriod: value);
  }

  void onTimeChanged(double value) {
    state = state.copyWith(
      time: DataNumber.dirty(value),
    );
  }

  void calculate() async {
    _touchEveryField();

    if (!state.isValid) return;

    double result = 0;
    switch (state.variable) {
      case CompoundVariable.amount:
        result = await repository.calculateAmountComp(
            capital: state.capital.value,
            capInterestRate: state.capInterestRate.value,
            typeInterestRate: state.typeInterestRate,
            capitalizationPeriod: state.capitalizationPeriod,
            time: state.time.value);
        break;

      case CompoundVariable.capital:
        result = await repository.calculateCapitalComp(
            amount: state.amount.value,
            capInterestRate: state.capInterestRate.value,
            typeInterestRate: state.typeInterestRate,
            capitalizationPeriod: state.capitalizationPeriod,
            time: state.time.value);
        break;

      case CompoundVariable.interestRate:
        result = await repository.calculateInterestRate(
            capital: state.capital.value,
            amount: state.amount.value,
            typeInterestRate: state.typeInterestRate,
            capitalizationPeriod: state.capitalizationPeriod,
            time: state.time.value);
        break;
      case CompoundVariable.interestRate2:
        result = await repository.calculateInterestRate2(
          capital: state.capital.value,
          amount: state.amount.value,
        );
        break;
      case CompoundVariable.time:
        result = await repository.calculateTimeComp(
            capital: state.capital.value,
            capInterestRate: state.capInterestRate.value,
            typeInterestRate: state.typeInterestRate,
            capitalizationPeriod: state.capitalizationPeriod,
            amount: state.amount.value);
        break;
      default:
        break;
    }
    state = state.copyWith(result: result);
  }

  void _touchEveryField() {
    state = state.copyWith(
      isFormPosted: true,
      amount: DataNumber.dirty(state.amount.value),
      capital: DataNumber.dirty(state.capital.value),
      capInterestRate: DataNumber.dirty(state.capInterestRate.value),
      time: DataNumber.dirty(state.time.value),
      isValid: state.variable != CompoundVariable.none &&
          Formz.validate([
            if (state.variable != CompoundVariable.capital) state.capital,
            if (state.variable != CompoundVariable.interestRate &&
                state.variable != CompoundVariable.interestRate2)
              state.capInterestRate,
            if (state.variable != CompoundVariable.time &&
                state.variable != CompoundVariable.interestRate2)
              state.time,
            if (state.variable != CompoundVariable.amount) state.amount,
          ]),
    );
  }
}
