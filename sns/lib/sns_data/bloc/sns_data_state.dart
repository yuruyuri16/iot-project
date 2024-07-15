part of 'sns_data_bloc.dart';

enum SnsDataStatus {
  initial,
  loading,
  success,
  failure;
}

final class SnsDataState extends Equatable {
  const SnsDataState({
    this.temperature = 0.0,
    this.humidity = 0.0,
    this.status = SnsDataStatus.initial,
  });

  final double temperature;
  final double humidity;
  final SnsDataStatus status;

  SnsDataState copyWith({
    double? temperature,
    double? humidity,
    SnsDataStatus? status,
  }) {
    return SnsDataState(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [temperature, humidity, status];
}
