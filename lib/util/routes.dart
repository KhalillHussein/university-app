import 'package:flutter/material.dart';

import '../ui/screens/error.dart';
import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const home = '/';
  static const teachers = '/teachers';
  static const info = '/info';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
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
        case info:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => Info(),
          );
        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  /// Method that called the error screen when necessary
  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ErrorScreen(),
    );
  }
}
