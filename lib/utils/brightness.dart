import 'package:screen_brightness/screen_brightness.dart';
import 'package:superiper_app/widgets/settings/utils/brightness.dart';

Future<void> boostBrightnessIfEnabled() async {
  if (!autoMaxBrightness.value) return;
  try {
    await ScreenBrightness().setApplicationScreenBrightness(1.0);
  } catch (_) {}
}
Future<void> restoreBrightness() async {
  if (!autoMaxBrightness.value) return;
  try {
    await ScreenBrightness().resetApplicationScreenBrightness();
  } catch (_) {}
}

