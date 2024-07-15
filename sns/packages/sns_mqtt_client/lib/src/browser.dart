import 'package:mqtt5_client/mqtt5_browser_client.dart';
import 'package:mqtt5_client/mqtt5_client.dart';

MqttClient setup(String serverAddress, String uniqueID) {
  return MqttBrowserClient.withPort(serverAddress, uniqueID, 9001);
}
