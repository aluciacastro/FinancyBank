import 'dart:math'; 
import 'package:cesarpay/domain/repositories/BondRepository.dart';

class BondRepositoryImpl implements BondRepository {
  @override
  double calculateBondValue({
    required double faceValue,
    required double couponRate,
    required int yearsToMaturity,
    required double marketRate,
  }) {
    double bondValue = 0.0;
    double couponPayment = faceValue * couponRate;

    for (int t = 1; t <= yearsToMaturity; t++) {
      bondValue += couponPayment / pow(1 + marketRate, t); 
    }

    bondValue += faceValue / pow(1 + marketRate, yearsToMaturity); 

    return bondValue;
  }
}

