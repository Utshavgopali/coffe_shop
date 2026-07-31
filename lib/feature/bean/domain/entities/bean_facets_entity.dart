import 'package:equatable/equatable.dart';

class BeanFacetsEntity extends Equatable {
  final Map<String, int> roastLevel;
  final Map<String, int> origin;
  final Map<String, int> weightGrams;

  const BeanFacetsEntity({
    this.roastLevel = const {},
    this.origin = const {},
    this.weightGrams = const {},
  });

  @override
  List<Object?> get props => [roastLevel, origin, weightGrams];
}
