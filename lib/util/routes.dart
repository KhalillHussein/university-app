// import 'package:flutter/material.dart';
//
// import '../ui/screens/error.dart';
// import '../ui/screens/index.dart';
//
// /// Class that holds both route names & generate methods.
// /// Used by the Flutter routing system
// class Routes {
//   // Static route names
//   static const home = '/';
//   static const teachers = '/teachers';
//   static const info = '/info';
//
//   /// Methods that generate all routes
//   static Route<dynamic> generateRoute(RouteSettings routeSettings) {
//     try {
//       switch (routeSettings.name) {
//         case home:
//           return MaterialPageRoute(
//             settings: routeSettings,
//             builder: (_) => NavigationScreen(),
//           );
//         case teachers:
//           return MaterialPageRoute(
//             settings: routeSettings,
//             builder: (_) => LecturersScreen(),
//           );
//         default:
//           return errorRoute(routeSettings);
//       }
//     } catch (_) {
//       return errorRoute(routeSettings);
//     }
//   }
//
//   /// Method that called the error screen when necessary
//   static Route<dynamic> errorRoute(RouteSettings routeSettings) {
//     return MaterialPageRoute(
//       settings: routeSettings,
//       builder: (_) => ErrorScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mtusiapp/ui/pages/index.dart';
import 'package:mtusiapp/ui/tabs/index.dart';

import '../ui/screens/error.dart';
import '../ui/screens/index.dart';

/// Class that holds both route names & generate methods.
/// Used by the Flutter routing system
class Routes {
  // Static route names
  static const home = '/';
  static const news = '/news';
  static const timetable = '/timetable';
  static const account = '/account';
  static const about = '/about';
  static const teachers = '/teachers';

  /// Methods that generate all routes
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      switch (routeSettings.name) {
        case home:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => NavigationScreen(),
          );
        case news:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => NewsTab(),
          );
        case timetable:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => TimetablePage(),
          );
        case account:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AuthTab(),
          );
        case about:
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => AboutTab(),
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
  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ErrorScreen(),
    );
  }
}
