import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infraestructure/infraestructure.dart';

final simpleRepositorytProvider = Provider((ref) {
  return CalculationSimpleRepositoryImpl();
});
