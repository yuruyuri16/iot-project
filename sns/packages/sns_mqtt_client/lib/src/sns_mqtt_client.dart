// import 'package:mqtt5_client/mqtt5_client.dart';
// import 'package:mqtt5_client/mqtt5_server_client.dart';
// import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'server.dart' if (dart.library.html) 'browser.dart' as mqttsetup;

/// Default QoS for the client
const defaultMqttQos = MqttQos.atLeastOnce;

///
class MessageData {
  ///
  const MessageData({
    required this.topic,
    required this.message,
  });

  ///
  final String topic;

  ///
  final String message;
}

/// {@template mqtt_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class SnsMqttClient {
  /// {@macro mqtt_client}
  SnsMqttClient({
    required String host,
    required String clientId,
  }) : _client = mqttsetup.setup(host, clientId)
          ..onConnected = (() {
            print('Connected');
          })
          ..onDisconnected = (() {
            print('disconnected');
          })
          ..onAutoReconnect = (() {
            print('Auto reconnect');
          })
          ..onAutoReconnected = (() {
            print('Auto reconnected');
          })
          ..onSubscribed = ((sub) {
            print('Subscribed to ${sub.topic}');
          })
          ..onSubscribeFail = ((sub) {
            print('Failed to subscribe to ${sub.topic}');
          });

  final MqttClient _client;

  // final BehaviorSubject<List<MessageData>> _subject = BehaviorSubject();

  ///
  Stream<List<MessageData>> get updates => _client.updates.map((messages) {
        final pt = MqttUtilities.bytesToStringAsString(
          (messages[0].payload as MqttPublishMessage).payload.message!,
        );
        print('FAKE:$pt from topic: ${messages[0].topic}');
        return messages.map((message) {
          final m = message.payload as MqttPublishMessage;
          final pt = MqttUtilities.bytesToStringAsString(m.payload.message!);
          return MessageData(topic: message.topic!, message: pt);
        }).toList();
      });

  ///
  Future<void> connect() async {
    _client.autoReconnect = true;

    try {
      await _client.connect();
    } catch (error, stackTrace) {
      print(error);
      Error.throwWithStackTrace(error, stackTrace);
    }

    _client.updates.listen((messages) {
      for (final message in messages) {
        final pt = MqttUtilities.bytesToStringAsString(
          (message.payload as MqttPublishMessage).payload.message!,
        );
        print('ORIGINAL:$pt from topic: ${message.topic}');
      }
    });
  }

  ///
  void subscribe(String topic) {
    try {
      _client.subscribe(topic, defaultMqttQos);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  ///
  Future<void> unsubscribe(String topic) async {
    try {
      _client.unsubscribeStringTopic(topic);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  ///
  Future<void> disconnect() async {
    try {
      _client.disconnect();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
