import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:momentoboothcompanionapp/app_localizations.dart';
import 'package:momentoboothcompanionapp/widgetbook.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // Use the generated directories variable
      directories: directories,
      addons: [
        GridAddon(10),
        AlignmentAddon(
          initialAlignment: Alignment.center,
        ),
        InspectorAddon(enabled: true),
      ],
      appBuilder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
          home: FluentTheme(
            data: FluentThemeData.light(),
            child: Material(child: child),
          ),
        );
      },
    );
  }
}
