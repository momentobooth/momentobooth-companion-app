import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtension on BuildContext {

  FluentThemeData get theme => FluentTheme.of(this);
  NavigatorState get navigator => Navigator.of(this);
  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);
  GoRouter get router => GoRouter.of(this);

}
