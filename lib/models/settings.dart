// ignore_for_file: invalid_annotation_target

import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@Freezed(fromJson: true, toJson: true)
class Settings with _$Settings {

  const Settings._();

  const factory Settings({
    @JsonKey(defaultValue: MqttSettings.withDefaults) required MqttSettings mqtt,
  }) = _Settings;

  factory Settings.withDefaults() => Settings.fromJson({});

  factory Settings.fromJson(Map<String, Object?> json) => _$SettingsFromJson(json);

  Settings withEnv() {
    return copyWith(
      mqtt: mqtt.withEnv(),
    );
  }

}

@Freezed(fromJson: true, toJson: true)
class MqttSettings with _$MqttSettings {

  const MqttSettings._();

  const factory MqttSettings({
    @Default("localhost") String host,
    @Default(1883) int port,
    @Default(false) bool secure,
    @Default(false) bool ignoreTlsErrors,
    @Default(false) bool useWebSocket,
    @Default("") String username,
    @Default("") String password,
    @Default("momentobooth-ca") String clientId,
    @Default("cups2mqtt") String cups2MqttRootTopic,
  }) = _MqttSettings;

  factory MqttSettings.withDefaults() => MqttSettings.fromJson({});

  factory MqttSettings.fromJson(Map<String, Object?> json) => _$MqttSettingsFromJson(json);

  MqttSettings withEnv() {
    String? secureEnvVar = Platform.environment["MBCA_MQTT_SECURE"];
    String? ignoreTlsErrorsEnvVar = Platform.environment["MBCA_MQTT_IGNORETLSERRORS"];
    String? useWebSocketEnvVar = Platform.environment["MBCA_MQTT_USEWEBSOCKET"];

    return copyWith(
      host: Platform.environment["MBCA_MQTT_HOST"] ?? host,
      port: int.tryParse(Platform.environment["MBCA_MQTT_PORT"] ?? "") ?? port,
      secure: secureEnvVar != null ? secureEnvVar == "true" : secure,
      ignoreTlsErrors: ignoreTlsErrorsEnvVar != null ? ignoreTlsErrorsEnvVar == "true" : ignoreTlsErrors,
      useWebSocket: useWebSocketEnvVar != null ? useWebSocketEnvVar == "true" : useWebSocket,
      username: Platform.environment["MBCA_MQTT_USERNAME"] ?? username,
      password: Platform.environment["MBCA_MQTT_PASSWORD"] ?? password,
      clientId: Platform.environment["MBCA_MQTT_CLIENTID"] ?? clientId,
      cups2MqttRootTopic: Platform.environment["MBCA_MQTT_C2M_ROOTTOPIC"] ?? cups2MqttRootTopic,
    );
  }

}
