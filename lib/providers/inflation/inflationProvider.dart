import 'package:cesarpay/domain/repositories/inflation_repository.dart';
import 'package:cesarpay/infraestructure/repositories/inflation_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// InflationFormState (el estado del formulario)
class InflationFormState {
  final double initialPrice;
  final double finalPrice;
  final bool isFormPosted;
  final double result;

  InflationFormState({
    required this.initialPrice,
    required this.finalPrice,
    required this.isFormPosted,
    required this.result,
  });

  InflationFormState copyWith({
    double? initialPrice,
    double? finalPrice,
    bool? isFormPosted,
    double? result,
  }) {
    return InflationFormState(
      initialPrice: initialPrice ?? this.initialPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      result: result ?? this.result,
    );
  }
}

// InflationFormNotifier (gestor del estado)
class InflationFormNotifier extends StateNotifier<InflationFormState> {
  final InflationRepository inflationRepository;

  InflationFormNotifier(this.inflationRepository)
      : super(InflationFormState(
          initialPrice: 0,
          finalPrice: 0,
          isFormPosted: false,
          result: 0,
        ));

  void onInitialPriceChanged(double value) {
    state = state.copyWith(initialPrice: value);
  }

  void onFinalPriceChanged(double value) {
    state = state.copyWith(finalPrice: value);
  }

  void calculateInflation() {
    final result = inflationRepository.calculateInflation(
      state.initialPrice,
      state.finalPrice,
    );

    state = state.copyWith(result: result, isFormPosted: true);
  }
}

// Provider para el formulario de inflación
final inflationFormProvider =
    StateNotifierProvider<InflationFormNotifier, InflationFormState>((ref) {
  final inflationRepository = ref.watch(inflationRepositoryProvider);
  return InflationFormNotifier(inflationRepository);
});

// Provider para el repositorio de inflación
final inflationRepositoryProvider = Provider<InflationRepository>((ref) {
  return InflationRepositoryImpl();
});
