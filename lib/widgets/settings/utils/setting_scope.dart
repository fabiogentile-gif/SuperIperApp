import 'package:flutter/material.dart';
import 'package:superiper_app/widgets/settings/utils/setting_controller.dart';

class SettingsScope extends InheritedNotifier<SettingController> {
  const SettingsScope({
    super.key,
    required SettingController settings,
    required super.child,
  }) : super(notifier: settings);

  static SettingController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsScope>()!.notifier!;
}
