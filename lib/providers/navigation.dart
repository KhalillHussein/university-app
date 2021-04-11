import 'package:flutter/foundation.dart';

enum Tabs { news, auth, about }

///Provider that performs navigation between pages
class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
