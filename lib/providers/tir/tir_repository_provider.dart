import 'package:cesarpay/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final tirRepositoryProvider = Provider((ref) {
  return CalculationTirRepositoryImpl();
});