import 'package:mobx/mobx.dart';
import 'package:momentoboothcompanionapp/misc/logger.dart';
import 'package:momentoboothcompanionapp/models/settings.dart';

part 'settings_manager.g.dart';

class SettingsManager = SettingsManagerBase with _$SettingsManager;

abstract class SettingsManagerBase with Store, Logger {

  @observable
  Settings? _settings;

  @computed
  Settings get settings => _settings!;

  // ////// //
  // Mutate //
  // ////// //

  @action
  void update(Settings settings) {
    if (settings == _settings) return;
    _settings = settings;
  }

}
