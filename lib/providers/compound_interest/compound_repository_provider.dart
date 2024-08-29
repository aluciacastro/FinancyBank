import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infraestructure/infraestructure.dart';

final compoundRepositorytProvider = Provider((ref) {
  return CalculationCompoundRepositoryImpl();
});
