import 'dart:async';
import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mobx/mobx.dart';
import 'package:momentoboothcompanionapp/exceptions/mqtt_exception.dart';
import 'package:momentoboothcompanionapp/main.dart';
import 'package:momentoboothcompanionapp/managers/settings_manager.dart';
import 'package:momentoboothcompanionapp/misc/logger.dart';
import 'package:momentoboothcompanionapp/models/app_enums.dart';
import 'package:momentoboothcompanionapp/models/mqtt/cups2mqtt.dart';
import 'package:momentoboothcompanionapp/models/settings.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:synchronized/synchronized.dart';

part 'mqtt_manager.g.dart';

class MqttManager = MqttManagerBase with _$MqttManager;

/// Class containing global state for photos in the app
abstract class MqttManagerBase with Store, Logger {

  final Lock _updateMqttClientInstanceLock = Lock();

  MqttSettings? _currentSettings;
  MqttServerClient? _client;

  @readonly
  ConnectionState _connectionState = ConnectionState.disconnected;

  @readonly
  IList<MqttCupsPrintQueueStatus> _printerStatuses = const IListConst<MqttCupsPrintQueueStatus>([]);

  // //////////////////////////////////// //
  // Initialization and client management //
  // //////////////////////////////////// //

  void initialize() {
    // Respond to settings changes
    autorun((_) {
      MqttSettings newMqttSettings = getIt<SettingsManager>().settings.mqtt;
      _updateMqttClientInstanceLock.synchronized(() async {
        await _recreateClient(newMqttSettings, false);
      });
    });
  }

  Future<void> _recreateClient(MqttSettings newSettings, bool passwordIsUpdated) async {
    if (newSettings == _currentSettings && !passwordIsUpdated) return;

    _client?.disconnect();
    _client = null;

    _connectionState = ConnectionState.connecting;
    MqttServerClient client = MqttServerClient.withPort(
      newSettings.host,
      newSettings.clientId,
      newSettings.port,
    )
      ..useWebSocket = newSettings.useWebSocket
      ..secure = newSettings.secure
      ..autoReconnect = true;

    if (newSettings.ignoreTlsErrors) {
      client.onBadCertificate = (certificate) => true;
    }

    try {
      MqttConnectionStatus? result = await client.connect(newSettings.username, newSettings.password);
      if (result?.state != MqttConnectionState.connected) {
        throw MqttException("Failed to connect to MQTT server: ${result?.reasonCode} ${result?.reasonString}");
      }

      logInfo("Connected to MQTT server");
      _client = client
        ..onDisconnected = (() => logInfo("Disconnected from MQTT server"))
        ..onAutoReconnect = (() {
          _connectionState = ConnectionState.connecting;
          logInfo("Reconnecting to MQTT server");
        })
        ..onAutoReconnected = (() {
          _connectionState = ConnectionState.connected;
          logInfo("Reconnected to MQTT server");
        });

      _connectionState = ConnectionState.connected;
      _createSubscriptionsAndHandleMessages(newSettings);
    } catch (e) {
      logError("Failed to connect to MQTT server: $e");
    }

    _currentSettings = newSettings;
  }

  // ///////////// //
  // Subscriptions //
  // ///////////// //

  void _createSubscriptionsAndHandleMessages(MqttSettings settings) {
    _subscribeToCups2MqttTopics(settings);
    _client!.updates.listen((messageList) {
      MqttPublishMessage? message;
      try {
        // From example: mqtt5_server_client_secure.dart
        message = messageList[0].payload as MqttPublishMessage;

        switch (message) {
          case MqttPublishMessage(:final variableHeader, :final payload) when variableHeader!.topicName.startsWith("${settings.cups2MqttRootTopic}/"):
            // Message from CUPS2MQTT
            if (payload.length == 0) return;
            _onCups2MqttMessage(
              variableHeader.topicName.substring("${settings.cups2MqttRootTopic}/".length),
              const Utf8Decoder().convert(payload.message!),
            );
          default:
            logWarning("Received unknown published MQTT message: $message");
        }
      } catch (e) {
        logError("Failed to parse published MQTT message (length: ${message?.payload.length}): $e");
      }
    });
  }

  void _subscribeToCups2MqttTopics(MqttSettings settings) {
    _client!.subscribe(
      "${settings.cups2MqttRootTopic}/#",
      MqttQos.atMostOnce,
    );
  }

  void _onCups2MqttMessage(String subtopic, String message) {
    final json = jsonDecode(message);

    switch (subtopic) {
      case "cups_server":
        logInfo("CUPS2MQTT server info: ${MqttCupsServerStatus.fromJson(json)}");
      default:
        final printerStatus = MqttCupsPrintQueueStatus.fromJson(json);
        logInfo("CUPS2MQTT printer info: $printerStatus");

        _printerStatuses = _printerStatuses.updateById([printerStatus], (existing) => existing.name == printerStatus.name);
    }
  }

}
