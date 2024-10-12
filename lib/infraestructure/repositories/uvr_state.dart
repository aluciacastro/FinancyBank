class UVRFormState {
  final double capital;
  final double interestRate;
  final int periods;
  final String result;
  final bool isFormPosted;

  UVRFormState({
    this.capital = 0,
    this.interestRate = 0,
    this.periods = 0,
    this.result = '',
    this.isFormPosted = false,
  });

  UVRFormState copyWith({
    double? capital,
    double? interestRate,
    int? periods,
    String? result,
    bool? isFormPosted,
  }) {
    return UVRFormState(
      capital: capital ?? this.capital,
      interestRate: interestRate ?? this.interestRate,
      periods: periods ?? this.periods,
      result: result ?? this.result,
      isFormPosted: isFormPosted ?? this.isFormPosted,
    );
  }
}
