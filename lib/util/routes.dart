import 'package:flutter/material.dart';

import '../models/index.dart';
import '../ui/pages/index.dart';
import '../ui/screens/index.dart';
import '../ui/screens/inquiries.dart';

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
          final lecturer = args['object'] as Lecturer;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => PersonalPage(lecturer),
          );
        case TimetableScreen.route:
          final timetableList = args['timetableList'] as List;
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => TimetableScreen(timetableList),
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
