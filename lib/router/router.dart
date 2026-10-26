import 'package:flutter/material.dart';
import 'package:superiper_app/pages/favorites.dart';
import 'package:superiper_app/pages/homepage.dart';
import 'package:superiper_app/pages/settings.dart';
import 'package:superiper_app/providers/card_provider.dart';
import 'package:superiper_app/shell.dart';

class AppRoutes {
  static const root = '/';
  static const homepage = '/homepage';
  static const setting = '/settings';
  static const favorites = '/favorites';

  // creato una sola volta per tutta l'app
  static final CardProvider cardProvider = CardProvider();

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
      case setting:
        page = const Settings();
      case favorites:
        page = Favorites( cardProvider: cardProvider);
      case homepage:
      default:
        page = HomePage(cardProvider: cardProvider);
    }
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}