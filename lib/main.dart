import 'package:flutter/material.dart';
import 'package:superiper_app/router/router.dart';
import 'package:superiper_app/shell.dart';
import 'package:superiper_app/theme/theme.dart';
import 'package:superiper_app/theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
        home: const AppShell(),
      ),
    );
  }
}
