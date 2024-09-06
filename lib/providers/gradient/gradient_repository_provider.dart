import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infraestructure/infraestructure.dart';

final gradientRepositorytProvider = Provider((ref) {
  return CalculationGradientRepositoryImpl();
});