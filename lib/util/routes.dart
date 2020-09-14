import 'package:flutter/material.dart';

import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  Routes._();
  static final Routes rt = Routes._();

  // Static route names
  static const home = '/';
  static const teachers = '/teachers';

  /// Methods that generate all routes
  Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      switch (routeSettings.name) {
        case home:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => NavigationScreen(),
          );
        case teachers:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => LecturersScreen(),
          );
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  /// Method that called the error screen when necessary
  Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => NavigationScreen(),
    );
  }
}
