// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cups2mqtt.freezed.dart';
part 'cups2mqtt.g.dart';

@freezed
class MqttCupsServerStatus with _$MqttCupsServerStatus {

  const factory MqttCupsServerStatus({
    @JsonKey(name: 'is_reachable') required bool isReachable,
    @JsonKey(name: 'cups_version') String? cupsVersion,
    @JsonKey(name: 'cups2mqtt_version') required String cups2mqttVersion,
  }) = _MqttCupsServerStatus;

  factory MqttCupsServerStatus.fromJson(Map<String, dynamic> json) => _$MqttCupsServerStatusFromJson(json);

}

@freezed
class MqttCupsPrintQueueStatus with _$MqttCupsPrintQueueStatus {

  const factory MqttCupsPrintQueueStatus({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'printer_make') required String printerMake,
    @JsonKey(name: 'state') required MqttCupsPrinterState state,
    @JsonKey(name: 'job_count') required int jobCount,
    @JsonKey(name: 'state_message') required String stateMessage,
    @JsonKey(name: 'state_reason') required String stateReason,
  }) = _MqttCupsPrintQueueStatus;

  factory MqttCupsPrintQueueStatus.fromJson(Map<String, dynamic> json) => _$MqttCupsPrintQueueStatusFromJson(json);

}

enum MqttCupsPrinterState {

  @JsonValue("Idle") idle,
  @JsonValue("Processing") processing,
  @JsonValue("Stopped") stopped,

}
