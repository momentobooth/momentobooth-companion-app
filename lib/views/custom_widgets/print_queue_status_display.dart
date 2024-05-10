import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:momentoboothcompanionapp/extensions/build_context_extension.dart';

class PrintQueueStatusDisplay extends StatelessWidget {

  final PrintQueueViewState statusState;
  final String? queueName;
  final int? jobsInQueue;
  final String? jobMessage;

  const PrintQueueStatusDisplay({
    super.key,
    required this.statusState,
    required this.queueName,
    required this.jobsInQueue,
    required this.jobMessage,
  });

  static const String _connectionIssueAnimationPath = 'assets/lottie/Animation - 1712763413483.json';
  //static const String _printerWarningAnimationPath = 'assets/lottie/Animation - 1709936404300.json';
  static const String _printingAnimationPath = 'assets/lottie/Animation - 1715327537292.json';
  static const String _printerIdleAnimationPath = 'assets/lottie/Animation - 1715329058493.json';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(queueName ?? "Unknown print queue", style: context.theme.typography.title),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: _getAnimation(context),
                  ),
                  if (_text.isNotEmpty)
                    Expanded(
                      flex: 2,
                      child: Text(
                        _text,
                        style: context.theme.typography.display!.copyWith(fontSize: 32.0),
                      ),
                    ),
                ]
              ),
            ),
          ),
          Text(
            "${jobsInQueue ?? "Unknown"} job${jobsInQueue == 1 ? '' : 's'} in queue",
            style: context.theme.typography.subtitle,
          ),
        ],
      ),
    );
  }

  String get _text {
    return switch (statusState) {
      PrintQueueViewState.noMqttConnection => "No connection to MQTT server",
      PrintQueueViewState.noCups2MqttTopicFound => "No CUPS2MQTT topic found",
      PrintQueueViewState.noPrinterFound => "No print queues found in MQTT state",
      _ => jobMessage ?? '',
    };
  }

  Widget _getAnimation(BuildContext context) {
    switch (statusState) {
      case PrintQueueViewState.noMqttConnection:
      case PrintQueueViewState.noCups2MqttTopicFound:
      case PrintQueueViewState.noPrinterFound:
        return Lottie.asset(
          _connectionIssueAnimationPath,
          frameRate: FrameRate.max,
        );
      case PrintQueueViewState.queueStatusAvailable when jobsInQueue == 0:
        return Lottie.asset(
          _printerIdleAnimationPath,
          frameRate: FrameRate.max,
        );
      case PrintQueueViewState.queueStatusAvailable:
        return Lottie.asset(
          _printingAnimationPath,
          frameRate: FrameRate.max,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.strokeColor(
                const ['**'],
                value: context.theme.accentColor,
              ),
            ],
          ),
        );
    }

  }

}

enum PrintQueueViewState {

  noMqttConnection,
  noCups2MqttTopicFound,
  noPrinterFound,
  queueStatusAvailable,

}
