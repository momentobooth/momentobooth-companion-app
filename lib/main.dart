import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:momentoboothcompanionapp/app_localizations.dart';
import 'package:momentoboothcompanionapp/managers/mqtt_manager.dart';
import 'package:momentoboothcompanionapp/managers/settings_manager.dart';
import 'package:momentoboothcompanionapp/models/settings.dart';
import 'package:momentoboothcompanionapp/src/rust/frb_generated.dart';
import 'package:momentoboothcompanionapp/views/printer_status/printer_status.dart';
import 'package:talker/talker.dart';

part 'main.routes.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  getIt
    ..registerSingleton(Talker(
      settings: TalkerSettings(),
    ))
    ..registerSingleton(SettingsManager()..update(Settings.withDefaults().withEnv()))
    ..registerSingleton(MqttManager()..initialize());

  getIt<Talker>().info("Starting Momento Booth Companion App");
  getIt<Talker>().debug("Settings: ${getIt<SettingsManager>().settings}");

  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  final GoRouter _router = GoRouter(routes: _routes);

  @override
  Widget build(BuildContext context) {
    Color accentColor = Colors.blue;

    return FluentApp.router(
      title: 'MomentoBooth Companion App',
      routerConfig: _router,
      color: Colors.green,
      theme: FluentThemeData(
        accentColor: AccentColor.swatch(
          {'normal': accentColor},
        ),
        dividerTheme: DividerThemeData(
          thickness: 2.0,
          decoration: BoxDecoration(color: accentColor),
          horizontalMargin: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FluentLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('nl'), // Dutch
      ],
    );
  }

}
