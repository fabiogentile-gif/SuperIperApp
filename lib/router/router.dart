import 'package:flutter/material.dart';
import 'package:superiper_app/pages/homepage.dart';
import 'package:superiper_app/pages/favorites.dart';
import 'package:superiper_app/pages/settings.dart';
import 'package:superiper_app/shell.dart';

class AppRoutes {
  static const root = '/';

  static const homepage = '/homepage';
  static const setting = '/settings';
  static const favorites = '/favorites';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppShell(),
        );
    }
    return null;
  }

  static Route<dynamic>? onGenerateTab(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case homepage:
        page = const HomePage();
      case setting:
        page = const Settings();
      case favorites:
        page = const Favorites();
      default:
        return null;
    }
    // senza animazione: i tab non devono scorrere
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
