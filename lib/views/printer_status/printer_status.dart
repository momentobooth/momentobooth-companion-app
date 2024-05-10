import 'package:momentoboothcompanionapp/views/base/build_context_accessor.dart';
import 'package:momentoboothcompanionapp/views/base/screen_base.dart';
import 'package:momentoboothcompanionapp/views/printer_status/printer_status_controller.dart';
import 'package:momentoboothcompanionapp/views/printer_status/printer_status_view.dart';
import 'package:momentoboothcompanionapp/views/printer_status/printer_status_view_model.dart';

class PrinterStatus extends ScreenBase<PrinterStatusViewModel, PrinterStatusController, PrinterStatusView> {

  const PrinterStatus({super.key});

  @override
  PrinterStatusController createController({required PrinterStatusViewModel viewModel, required BuildContextAccessor contextAccessor}) {
    return PrinterStatusController(viewModel: viewModel, contextAccessor: contextAccessor);
  }

  @override
  PrinterStatusView createView({required PrinterStatusController controller, required PrinterStatusViewModel viewModel, required BuildContextAccessor contextAccessor}) {
    return PrinterStatusView(viewModel: viewModel, controller: controller, contextAccessor: contextAccessor);
  }

  @override
  PrinterStatusViewModel createViewModel({required BuildContextAccessor contextAccessor}) {
    return PrinterStatusViewModel(contextAccessor: contextAccessor);
  }

}
