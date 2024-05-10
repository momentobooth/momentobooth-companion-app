import 'package:mobx/mobx.dart';
import 'package:momentoboothcompanionapp/main.dart';
import 'package:momentoboothcompanionapp/managers/mqtt_manager.dart';
import 'package:momentoboothcompanionapp/models/app_enums.dart';
import 'package:momentoboothcompanionapp/models/mqtt/cups2mqtt.dart';
import 'package:momentoboothcompanionapp/views/base/screen_view_model_base.dart';
import 'package:momentoboothcompanionapp/views/custom_widgets/print_queue_status_display.dart';

part 'printer_status_view_model.g.dart';

class PrinterStatusViewModel = PrinterStatusViewModelBase with _$PrinterStatusViewModel;

abstract class PrinterStatusViewModelBase extends ScreenViewModelBase with Store {

  @computed
  PrintQueueViewState get viewState {
  	final mqttManager = getIt<MqttManager>();

    if (mqttManager.connectionState != ConnectionState.connected) {
      return PrintQueueViewState.noMqttConnection;
    } else if (mqttManager.printerStatuses == null) {
      return PrintQueueViewState.noCups2MqttTopicFound;
    } else if (mqttManager.printerStatuses!.isEmpty) {
      return PrintQueueViewState.noPrinterFound;
    } else {
      return PrintQueueViewState.queueStatusAvailable;
    }
  }

  @computed
  MqttCupsPrintQueueStatus? get _printQueue => getIt<MqttManager>().printerStatuses?.firstOrNull;

  @computed
  String get queueName => _printQueue?.description ?? "Unknown print queue";

  @computed
  int? get jobCount => _printQueue?.jobCount;

  @computed
  String? get statusMessage => _printQueue?.stateMessage;

  PrinterStatusViewModelBase({
    required super.contextAccessor,
  });

}
