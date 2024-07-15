import 'package:sns/app/app.dart';
import 'package:sns/bootstrap.dart';
import 'package:sns_client/sns_client.dart';
import 'package:sns_mqtt_client/sns_mqtt_client.dart';
import 'package:sns_repository/sns_repository.dart';

void main() {
  bootstrap(() async {
    final mqttClient = SnsMqttClient(host: '192.168.18.47', clientId: 'sns');
    final apiClient = SnsClient();

    final snsRepository = SnsRepository(
      apiClient: apiClient,
      mqttClient: mqttClient,
    );
    await snsRepository.init();

    return App(
      snsRepository: snsRepository,
    );
  });
}
