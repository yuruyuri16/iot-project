import 'dart:convert';

import 'package:sns_client/sns_client.dart';
import 'package:sns_mqtt_client/sns_mqtt_client.dart';

/// {@template sns_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class SnsRepository {
  /// {@macro sns_repository}
  const SnsRepository({
    required SnsClient apiClient,
    required SnsMqttClient mqttClient,
  })  : _mqttClient = mqttClient,
        _apiClient = apiClient;

  final SnsMqttClient _mqttClient;
  final SnsClient _apiClient;

  ///
  Stream<Climate> get sensorData => _mqttClient.updates.expand((messages) {
        return messages
            .where((message) => message.topic == 'sensor_clean')
            .map((message) {
          final x = jsonDecode(message.message) as Map<String, dynamic>;
          return Climate.fromJson(x);
        });
      }).handleError(print);

  ///
  Future<void> init() async {
    await _mqttClient.connect();
    _mqttClient.subscribe('sensor_clean');
  }

  ///
  Future<List<Climate>> getSensorData() async {
    return _apiClient.getSensorData();
  }
}
