import 'package:flutter/material.dart';
import 'package:superiper_app/router/router.dart';
import 'package:superiper_app/theme/theme.dart';
import 'package:superiper_app/theme/theme_controller.dart';
import 'package:superiper_app/widgets/settings/utils/brightness.dart';
import 'package:superiper_app/widgets/settings/utils/default_holder_controller.dart';
import 'package:superiper_app/widgets/settings/utils/setting_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await SettingController.load();

  themeMode.value = settings.themeMode;
  defaultHolderName.value = settings.defaultHolder;
  autoMaxBrightness.value = settings.autoMaxBrightness;

  themeMode.addListener(() => settings.setThemeMode(themeMode.value));
  defaultHolderName.addListener(
    () => settings.setDefaultHolder(defaultHolderName.value),
  );
  autoMaxBrightness.addListener(
    () => settings.setAutoMaxBrightness(autoMaxBrightness.value),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        debugShowCheckedModeBanner: true, //da togliere dopo

        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        initialRoute: AppRoutes.root,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        title: 'APP',
      ),
    );
  }
}
