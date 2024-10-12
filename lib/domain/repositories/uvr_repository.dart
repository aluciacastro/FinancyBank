abstract class UVRRepository {
  double calculateUVR(double capital, double interestRate, int periods);
}

class UVRRepositoryImpl implements UVRRepository {
  @override
  double calculateUVR(double capital, double interestRate, int periods) {
    // Aquí defines la fórmula para el cálculo de la UVR.
    return capital * (1 + (interestRate / 100) * periods);
  }
}
