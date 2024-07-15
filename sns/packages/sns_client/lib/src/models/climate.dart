import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'climate.g.dart';

/// {@template climate}
/// {@endtemplate}
@JsonSerializable(createToJson: false)
final class Climate extends Equatable {
  /// {@macro climate}
  const Climate({
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

  /// Converts a [Map<String, dynamic>] to a [Climate].
  factory Climate.fromJson(Map<String, dynamic> json) =>
      _$ClimateFromJson(json);

  /// The temperature.
  final double temperature;

  /// The humidity.
  final double humidity;

  /// The timestamp.
  final DateTime timestamp;

  @override
  List<Object?> get props => [temperature, humidity, timestamp];
}
