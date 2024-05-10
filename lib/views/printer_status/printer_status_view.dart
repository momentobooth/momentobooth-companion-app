import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momentoboothcompanionapp/views/base/screen_view_base.dart';
import 'package:momentoboothcompanionapp/views/custom_widgets/print_queue_status_display.dart';
import 'package:momentoboothcompanionapp/views/printer_status/printer_status_controller.dart';
import 'package:momentoboothcompanionapp/views/printer_status/printer_status_view_model.dart';

class PrinterStatusView extends ScreenViewBase<PrinterStatusViewModel, PrinterStatusController> {

  const PrinterStatusView({
    required super.viewModel,
    required super.controller,
    required super.contextAccessor,
  });

  @override
  Widget get body {
    return ColoredBox(
      color: Colors.white,
      child: Observer(
        builder: (_) {
          return PrintQueueStatusDisplay(
            statusState: viewModel.viewState,
            queueName: viewModel.queueName,
            jobsInQueue: viewModel.jobCount,
            jobMessage: viewModel.statusMessage,
          );
        }
      ),
    );
  }

}
