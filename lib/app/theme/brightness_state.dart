import 'package:equatable/equatable.dart';

class BrightnessState extends Equatable {
  final bool autoBrightnessEnabled;

  const BrightnessState({this.autoBrightnessEnabled = false});

  BrightnessState copyWith({bool? autoBrightnessEnabled}) {
    return BrightnessState(
      autoBrightnessEnabled: autoBrightnessEnabled ?? this.autoBrightnessEnabled,
    );
  }

  @override
  List<Object?> get props => [autoBrightnessEnabled];
}
