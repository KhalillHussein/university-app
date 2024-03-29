import 'package:flutter/material.dart';

import '../ui/views/pages/index.dart';
import '../ui/views/screens/index.dart';
import '../ui/views/screens/inquiries.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      final Map<String, dynamic> args = routeSettings.arguments;
      switch (routeSettings.name) {
        case NavigationScreen.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => NavigationScreen(),
          );
        case LecturersScreen.route:
          final kafedra = args['kafedra'] as String;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => LecturersScreen(kafedra),
          );
        case InquiriesScreen.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => InquiriesScreen(),
          );
        case PhoneBookScreen.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PhoneBookScreen(),
          );
        case PersonalPage.route:
          final lecturer = args['name'] as String;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PersonalPage(lecturer),
          );
        case NewsCreateScreen.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => NewsCreateScreen(),
          );
        case ChangelogScreen.route:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ChangelogScreen(),
          );
        case SettingsScreen.route:
          return MaterialPageRoute(
            builder: (_) => SettingsScreen(),
          );
        case CalendarScreen.route:
          return MaterialPageRoute(
            builder: (_) => CalendarScreen(),
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
