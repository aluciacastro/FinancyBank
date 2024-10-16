import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/amortization_repository.dart';
import '../../infraestructure/repositories/amortization_repository_imp.dart';

final amortizationProvider = StateNotifierProvider<AmortizationNotifier, AmortizationFormState>((ref) {
  return AmortizationNotifier(ref);
});

class AmortizationFormState {
  final double capital;
  final double interestRate;
  final int periods;
  final String amortizationType;
  final List<Map<String, double>> payments; // Detalles de cada pago
  final bool isFormPosted;
  final String message; // Agregar un campo para el mensaje

  AmortizationFormState({
    this.capital = 0,
    this.interestRate = 0,
    this.periods = 0,
    this.amortizationType = 'Francesa',
    this.payments = const [],  // Inicializado como lista vacía
    this.isFormPosted = false,
    this.message = '', // Inicializar el mensaje como una cadena vacía
  });

  AmortizationFormState copyWith({
    double? capital,
    double? interestRate,
    int? periods,
    String? amortizationType,
    List<Map<String, double>>? payments,
    bool? isFormPosted,
    String? message, // Permitir que el mensaje sea opcional en copyWith
  }) {
    return AmortizationFormState(
      capital: capital ?? this.capital,
      interestRate: interestRate ?? this.interestRate,
      periods: periods ?? this.periods,
      amortizationType: amortizationType ?? this.amortizationType,
      payments: payments ?? this.payments,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      message: message ?? this.message, // Usar el mensaje anterior si no se proporciona uno nuevo
    );
  }
}

class AmortizationNotifier extends StateNotifier<AmortizationFormState> {
  final AmortizationRepository _repository;

  AmortizationNotifier(Ref ref)
      : _repository = AmortizationRepositoryImpl(),
        super(AmortizationFormState());

  void onCapitalChanged(double capital) {
    state = state.copyWith(capital: capital, message: ''); // Actualizar el mensaje si es necesario
  }

  void onInterestRateChanged(double rate) {
    state = state.copyWith(interestRate: rate, message: ''); // Actualizar el mensaje si es necesario
  }

  void onPeriodsChanged(int periods) {
    state = state.copyWith(periods: periods, message: ''); // Actualizar el mensaje si es necesario
  }

  void onAmortizationTypeChanged(String type) {
    state = state.copyWith(amortizationType: type, message: ''); // Actualizar el mensaje si es necesario
  }

  void calculateAmortization() {
    List<AmortizationPayment> amortizationPayments;

    // Determina el tipo de amortización
    if (state.amortizationType == 'Francesa') {
      amortizationPayments = _repository.calculateFrenchAmortization(state.capital, state.interestRate, state.periods);
    } else if (state.amortizationType == 'Alemana') {
      amortizationPayments = _repository.calculateGermanAmortization(state.capital, state.interestRate, state.periods);
    } else {
      amortizationPayments = _repository.calculateAmericanAmortization(state.capital, state.interestRate, state.periods);
    }
    
    // Convierte los pagos de AmortizationPayment a Map<String, double>
    List<Map<String, double>> payments = amortizationPayments.map((payment) {
      return {
        'cuota': payment.cuota,
        'interes': payment.interes,
        'amortizacion': payment.amortizacion,
      };
    }).toList();

    // Actualiza el estado
    state = state.copyWith(payments: payments, isFormPosted: true, message: ''); // Puedes actualizar el mensaje según sea necesario
  }
}
