import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../../infraestructure/infraestructure.dart';
import '../providers.dart';

final simpleFormProvider =
    StateNotifierProvider.autoDispose<SimpleFormNotifier, SimpleFormState>(
        (ref) {
  final simpleInterestRepository = ref.watch(simpleRepositorytProvider);

  return SimpleFormNotifier(
    repository: simpleInterestRepository,
  );
});

enum SimpleVariable { none, amount, capital, interest, time, interestRate }

class SimpleFormState {
  final menuOptions = const <SimpleVariable, String>{
    SimpleVariable.amount: "Monto",
    SimpleVariable.capital: "Capital",
    SimpleVariable.interest: "Interes",
    SimpleVariable.time: "Tiempo",
    SimpleVariable.interestRate: "Tasa de Interés",
  };

  final bool isFormPosted;
  final bool isValid;
  final SimpleVariable variable;
  final DataNumber capital;
  final DataPercentage rateInterest;
  final DataNumber time;
  final DataNumber interest;
  final String result;

  SimpleFormState({
    this.isFormPosted = false,
    this.isValid = false,
    this.variable = SimpleVariable.none,
    this.capital = const DataNumber.pure(),
    this.rateInterest = const DataPercentage.pure(),
    this.time = const DataNumber.pure(),
    this.interest = const DataNumber.pure(),
    this.result = "",
  });

  SimpleFormState copyWith({
    bool? isFormPosted,
    bool? isValid,
    SimpleVariable? variable,
    DataNumber? capital,
    DataPercentage? rateInterest,
    DataNumber? time,
    DataNumber? interest,
    String? result,
  }) =>
      SimpleFormState(
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        variable: variable ?? this.variable,
        capital: capital ?? this.capital,
        rateInterest: rateInterest ?? this.rateInterest,
        time: time ?? this.time,
        interest: interest ?? this.interest,
        result: result ?? this.result,
      );
}

class SimpleFormNotifier extends StateNotifier<SimpleFormState> {
  CalculationSimpleRepositoryImpl repository;

  SimpleFormNotifier({
    required this.repository,
  }) : super(SimpleFormState());

  void onOptionsSimpleChanged(SimpleVariable value) {
    state = state.copyWith(variable: value);
    clearFieldsAndResult();
  }

  void clearFieldsAndResult() {
    state = state.copyWith(
      capital: const DataNumber.pure(),
      rateInterest: const DataPercentage.pure(),
      time: const DataNumber.pure(),
      interest: const DataNumber.pure(),
      result: "",
      isFormPosted: false,
      isValid: false,
    );
  }

  void onCapitalChanged(double value) {
    state = state.copyWith(
      capital: DataNumber.dirty(value),
    );
  }

  void onInterestChanged(double value) {
    state = state.copyWith(
      interest: DataNumber.dirty(value),
    );
  }

  void onRateInterestChanged(double value) {
    state = state.copyWith(
      rateInterest: DataPercentage.dirty(value),
    );
  }

  void onTimeChanged(double value) {
    state = state.copyWith(
      time: DataNumber.dirty(value),
    );
  }

  void calculate() async {
    _touchEveryField();

    if (!state.isValid) return;

    String result = "";
    switch (state.variable) {
      case SimpleVariable.amount:
        double amount = await repository.finalAmount(
          capital: state.capital.value,
          rateInterest: state.rateInterest.value,
          time: state.time.value,
        );
        result = amount.toString();
        break;

      case SimpleVariable.capital:
        double capital = await repository.capital(
            interest: state.interest.value,
            rateInterest: state.rateInterest.value,
            time: state.time.value);
        result = capital.toString();
        break;

      case SimpleVariable.interestRate:
        double interestRate = await repository.rateInterest(
            capital: state.capital.value,
            interest: state.interest.value,
            time: state.time.value);
        result = interestRate.toString();
        break;

      case SimpleVariable.time:
        result = await repository.time(
            capital: state.capital.value,
            rateInterest: state.rateInterest.value,
            interest: state.interest.value);
        break;

      case SimpleVariable.interest:
        double interest = await repository.interest(
            capital: state.capital.value,
            rateInterest: state.rateInterest.value,
            time: state.time.value);
        result = interest.toString();
        break;
      default:
        break;
    }
    state = state.copyWith(result: result);
  }

  void _touchEveryField() {
    state = state.copyWith(
      isFormPosted: true,
      capital: DataNumber.dirty(state.capital.value),
      time: DataNumber.dirty(state.time.value),
      rateInterest: DataPercentage.dirty(state.rateInterest.value),
      interest: DataNumber.dirty(state.interest.value),
      isValid: state.variable != SimpleVariable.none &&
          Formz.validate([
            if (state.variable != SimpleVariable.capital) state.capital,
            if (state.variable != SimpleVariable.interestRate)
              state.rateInterest,
            if (state.variable != SimpleVariable.time) state.time,
            if (state.variable != SimpleVariable.interest &&
                state.variable != SimpleVariable.amount)
              state.interest,
          ]),
    );
  }
}
