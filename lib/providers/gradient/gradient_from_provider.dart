import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../infraestructure/infraestructure.dart';
import 'gradient_repository_provider.dart';

final gradientFormProvider =
    StateNotifierProvider.autoDispose<GradientFormNotifier, GradientFromState>(
        (ref) {
  final gradientRepository = ref.watch(gradientRepositorytProvider);

  return GradientFormNotifier(
    repository: gradientRepository,
  );
});

enum GradientType {
  none,
  aritmetic,
  geometric,
}

enum GradientVariableA {
  none,
  presentValueAIncreasing,
  futureValueAIncreasing,
  presentValueADecreasing,
  futureValueADecreasing,
}

enum GradientVariableG {
  none,
  presentValueGIncreasing,
  futureValueGIncreasing,
  presentValueGDecreasing,
  futureValueGDecreasing,
}

class GradientFromState {
  final menuOptions = const <GradientType, String>{
    GradientType.aritmetic: "Aritmetico",
    GradientType.geometric: "Geometrico",
  };
  // Tipo de variable de Gradiente Aritmetico
  final menuOptionsTypeVariableA = const <GradientVariableA, String>{
    GradientVariableA.presentValueAIncreasing: "Valor Presente creciente A",
    GradientVariableA.futureValueAIncreasing: "Valor Futuro creciente A",
    GradientVariableA.presentValueADecreasing: "Valor Presente decreciente A",
    GradientVariableA.futureValueADecreasing: "Valor Futuro decreciente A",
  };

  // Tipo de variable de Gradiente geometrico
  final menuOptionsTypeVariableG = const <GradientVariableG, String>{
    GradientVariableG.presentValueGIncreasing: "Valor Presente creciente G",
    GradientVariableG.futureValueGIncreasing: "Valor Futuro creciente G",
    GradientVariableG.presentValueGDecreasing: "Valor Presente decreciente G",
    GradientVariableG.futureValueGDecreasing: "Valor Futuro decreciente G",
  };

  // Función para obtener las opciones de tipo de variable basadas en el tipo de gradiente
  Map<Enum, String> getVariableOptions(GradientType gradientType) {
    return gradientType == GradientType.aritmetic
        ? menuOptionsTypeVariableA
        : gradientType == GradientType.geometric
            ? menuOptionsTypeVariableG
            : {};
  }

  final bool isFormPosted;
  final bool isValid;
  final GradientType typeGradiente;
  final GradientVariableA variableA;
  final GradientVariableG variableG;
  final DataNumber paymentSeries;
  final DataNumber variationG;
  final DataNumber interestRate;
  final DataNumber numPeriod;
  final double result;

  GradientFromState({
    this.isFormPosted = false,
    this.isValid = false,
    this.typeGradiente = GradientType.none,
    this.variableA = GradientVariableA.none,
    this.variableG = GradientVariableG.none,
    this.paymentSeries = const DataNumber.pure(),
    this.variationG = const DataNumber.pure(),
    this.interestRate = const DataNumber.pure(),
    this.numPeriod = const DataNumber.pure(),
    this.result = 0,
  });

  GradientFromState copyWith({
    bool? isFormPosted,
    bool? isValid,
    GradientType? typeGradiente,
    GradientVariableA? variableA,
    GradientVariableG? variableG,
    DataNumber? paymentSeries,
    DataNumber? variationG,
    DataNumber? interestRate,
    DataNumber? numPeriod,
    double? result,
  }) =>
      GradientFromState(
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        typeGradiente: typeGradiente ?? this.typeGradiente,
        variableA: variableA ?? this.variableA,
        variableG: variableG ?? this.variableG,
        paymentSeries: paymentSeries ?? this.paymentSeries,
        variationG: variationG ?? this.variationG,
        interestRate: interestRate ?? this.interestRate,
        numPeriod: numPeriod ?? this.numPeriod,
        result: result ?? this.result,
      );
}

class GradientFormNotifier extends StateNotifier<GradientFromState> {
  CalculationGradientRepositoryImpl repository;

  GradientFormNotifier({
    required this.repository,
  }) : super(GradientFromState());

  void onOptionsGradientChanged(GradientType value) {
    state = state.copyWith(typeGradiente: value);
  }

  void onOptionsGradientVariableAChanged(GradientVariableA value) {
    state = state.copyWith(variableA: value);
  }

  void onOptionsGradientVariableGChanged(GradientVariableG value) {
    state = state.copyWith(variableG: value);
  }

  void onOptionsGradientVariableChanged(Enum variable, String value) {
    if (variable is GradientVariableA) {
      onOptionsGradientVariableAChanged(variable);
    } else if (variable is GradientVariableG) {
      onOptionsGradientVariableGChanged(variable);
    }
  }

  void onPaymentSeriesChanged(double value) {
    state = state.copyWith(
      paymentSeries: DataNumber.dirty(value),
    );
  }

  void onVariationGChanged(double value) {
    state = state.copyWith(
      variationG: DataNumber.dirty(value),
    );
  }

  void onInterestRateChanged(double value) {
    state = state.copyWith(
      interestRate: DataNumber.dirty(value),
    );
  }

  void onNumPeriodChanged(double value) {
    state = state.copyWith(
      numPeriod: DataNumber.dirty(value),
    );
  }

// Calculo para el formulario de tipo de gradiente

  void calculate() async {
    _touchEveryField();

    if (!state.isValid) return;

    double result = 0;

    switch (state.typeGradiente) {
      case GradientType.aritmetic:
        result = await _calculateAritmeticGradient();
        break;
      case GradientType.geometric:
        result = await _calculateGeometricGradient();
        break;
      default:
        break;
    }

    state = state.copyWith(result: result);
  }

  Future<double> _calculateAritmeticGradient() async {
    double result = 0;

    switch (state.variableA) {
      case GradientVariableA.presentValueAIncreasing:
        result = await repository.calculateGradientAIncreasingVP(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      case GradientVariableA.futureValueAIncreasing:
        result = await repository.calculateGradientAIncreasingVF(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      case GradientVariableA.presentValueADecreasing:
        result = await repository.calculateGradientADecreasingVP(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      case GradientVariableA.futureValueADecreasing:
        result = await repository.calculateGradientADecreasingVF(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      default:
        break;
    }

    return result;
  }

  Future<double> _calculateGeometricGradient() async {
    double result = 0;

    switch (state.variableG) {
      case GradientVariableG.presentValueGIncreasing:
        result = await repository.calculateGradientGIncreasingVP(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      case GradientVariableG.futureValueGIncreasing:
        result = await repository.calculateGradientGIncreasingVF(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      case GradientVariableG.presentValueGDecreasing:
        result = await repository.calculateGradientGDecreasingVP(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      case GradientVariableG.futureValueGDecreasing:
        result = await repository.calculateGradientGDecreasingVF(
          paymentSeries: state.paymentSeries.value,
          variationG: state.variationG.value,
          interestRate: state.interestRate.value,
          numPeriod: state.numPeriod.value,
        );
        break;
      default:
        break;
    }

    return result;
  }

  void _touchEveryField() {
    state = state.copyWith(
      isFormPosted: true,
      paymentSeries: DataNumber.dirty(state.paymentSeries.value),
      variationG: DataNumber.dirty(state.variationG.value),
      interestRate: DataNumber.dirty(state.interestRate.value),
      numPeriod: DataNumber.dirty(state.numPeriod.value),
      isValid: state.typeGradiente != GradientType.none &&
          ((state.typeGradiente == GradientType.aritmetic &&
                  state.variableA != GradientVariableA.none) ||
              (state.typeGradiente == GradientType.geometric &&
                  state.variableG != GradientVariableG.none)) &&
          Formz.validate([
            if (state.typeGradiente == GradientType.aritmetic &&
                (state.variableA != GradientVariableA.presentValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.presentValueADecreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueADecreasing))
              state.paymentSeries,
            if (state.typeGradiente == GradientType.aritmetic &&
                (state.variableA != GradientVariableA.presentValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.presentValueADecreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueADecreasing))
              state.variationG,
            if (state.typeGradiente == GradientType.aritmetic &&
                (state.variableA != GradientVariableA.presentValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.presentValueADecreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueADecreasing))
              state.interestRate,
            if (state.typeGradiente == GradientType.aritmetic &&
                (state.variableA != GradientVariableA.presentValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueAIncreasing &&
                    state.variableA !=
                        GradientVariableA.presentValueADecreasing &&
                    state.variableA !=
                        GradientVariableA.futureValueADecreasing))
              state.numPeriod,
            if (state.typeGradiente == GradientType.geometric &&
                (state.variableG != GradientVariableG.presentValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.presentValueGDecreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGDecreasing))
              state.paymentSeries,
            if (state.typeGradiente == GradientType.geometric &&
                (state.variableG != GradientVariableG.presentValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.presentValueGDecreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGDecreasing))
              state.variationG,
            if (state.typeGradiente == GradientType.geometric &&
                (state.variableG != GradientVariableG.presentValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.presentValueGDecreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGDecreasing))
              state.interestRate,
            if (state.typeGradiente == GradientType.geometric &&
                (state.variableG != GradientVariableG.presentValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGIncreasing &&
                    state.variableG !=
                        GradientVariableG.presentValueGDecreasing &&
                    state.variableG !=
                        GradientVariableG.futureValueGDecreasing))
              state.numPeriod,
          ]),
    );
  }
}
