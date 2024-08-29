import '../domain.dart';

double formulaTipoInteres(TypeInterestRate typeInterestRate,
    CapitalizationPeriod capitalizationPeriod) {
  double conversionFactor = 0;

  final Map<TypeInterestRate, Map<CapitalizationPeriod, double>>
      conversionFactors = {
    // Factor Dias
    TypeInterestRate.diario: {
      CapitalizationPeriod.anual: 360.00,
      CapitalizationPeriod.mensual: 30.00,
      CapitalizationPeriod.semestral: 180.00,
      CapitalizationPeriod.trimestral: 90.00,
      CapitalizationPeriod.bimestral: 60.00,
      CapitalizationPeriod.diario: 1.00,
    },
    // Factor Mensual
    TypeInterestRate.mensual: {
      CapitalizationPeriod.anual: 12.00,
      CapitalizationPeriod.mensual: 1.00,
      CapitalizationPeriod.semestral: 1 / 30,
      CapitalizationPeriod.trimestral: 2.00,
      CapitalizationPeriod.bimestral: 3.00,
      CapitalizationPeriod.diario: 1 / 30,
    },
    // Factor Semestral
    TypeInterestRate.semestral: {
      CapitalizationPeriod.anual: 2.00,
      CapitalizationPeriod.mensual: 6.00,
      CapitalizationPeriod.semestral: 1.00,
      CapitalizationPeriod.trimestral: 3.00,
      CapitalizationPeriod.bimestral: 1.50,
      CapitalizationPeriod.diario: 1 / 180,
    },
    // Factor Trimestral
    TypeInterestRate.trimestral: {
      CapitalizationPeriod.anual: 4.00,
      CapitalizationPeriod.mensual: 3.00,
      CapitalizationPeriod.semestral: 1 / 2,
      CapitalizationPeriod.trimestral: 1.00,
      CapitalizationPeriod.bimestral: 2.00,
      CapitalizationPeriod.diario: 1 / 90,
    },
    // Factor Bimestral
    TypeInterestRate.bimestral: {
      CapitalizationPeriod.anual: 6.00,
      CapitalizationPeriod.mensual: 2.00,
      CapitalizationPeriod.semestral: 3 / 2,
      CapitalizationPeriod.trimestral: 1 / 2,
      CapitalizationPeriod.bimestral: 1.00,
      CapitalizationPeriod.diario: 1 / 60,
    },
    // Factor Anual
    TypeInterestRate.anual: {
      CapitalizationPeriod.anual: 1.00,
      CapitalizationPeriod.mensual: 1 / 12,
      CapitalizationPeriod.semestral: 1 / 360,
      CapitalizationPeriod.trimestral: 1 / 6,
      CapitalizationPeriod.bimestral: 1 / 4,
      CapitalizationPeriod.diario: 1 / 360,
    },
  };

  conversionFactor =
      conversionFactors[typeInterestRate]![capitalizationPeriod]!;

  return conversionFactor;
}
