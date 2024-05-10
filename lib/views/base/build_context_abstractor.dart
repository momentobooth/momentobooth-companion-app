import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:momentoboothcompanionapp/app_localizations.dart';
import 'package:momentoboothcompanionapp/extensions/build_context_extension.dart';
import 'package:momentoboothcompanionapp/views/base/build_context_accessor.dart';
import 'package:momentoboothcompanionapp/views/base/dialog_page.dart';

mixin BuildContextAbstractor {

  BuildContextAccessor get contextAccessor;
  BuildContext get _context => contextAccessor.buildContext;

  FluentThemeData get theme => _context.theme;
  GoRouter get router => _context.router;

  NavigatorState get navigator => _context.navigator;
  NavigatorState get rootNavigator => _context.rootNavigator;

  AppLocalizations get localizations => AppLocalizations.of(_context)!;

  Future<void> showUserDialog({required Widget dialog, required bool barrierDismissible}) async {
    await navigator.push(DialogPage(
      key: null,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: dialog),
      ),
      barrierDismissible: barrierDismissible,
    ).createRoute(_context));
  }

}
