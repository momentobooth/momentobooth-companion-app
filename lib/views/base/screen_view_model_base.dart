import 'package:meta/meta.dart';
import 'package:momentoboothcompanionapp/views/base/build_context_abstractor.dart';
import 'package:momentoboothcompanionapp/views/base/build_context_accessor.dart';

abstract class ScreenViewModelBase with BuildContextAbstractor {

  @override
  final BuildContextAccessor contextAccessor;

  ScreenViewModelBase({
    required this.contextAccessor,
  });

  @mustCallSuper
  void dispose() {}

}
