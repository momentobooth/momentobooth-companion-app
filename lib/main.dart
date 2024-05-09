import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:momentoboothcompanionapp/managers/mqtt_manager.dart';
import 'package:momentoboothcompanionapp/managers/settings_manager.dart';
import 'package:momentoboothcompanionapp/models/settings.dart';
import 'package:momentoboothcompanionapp/src/rust/api/simple.dart';
import 'package:momentoboothcompanionapp/src/rust/frb_generated.dart';
import 'package:talker/talker.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  getIt.registerSingleton(Talker(
    settings: TalkerSettings(),
  ));
  getIt.registerSingleton(SettingsManager()..update(Settings.withDefaults().withEnv()));
  getIt.registerSingleton(MqttManager()..initialize());

  getIt<Talker>().info("Starting Momento Booth Companion App");
  getIt<Talker>().debug("Settings: ${getIt<SettingsManager>().settings}");

  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: Text('Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
        ),
      ),
    );
  }
}
