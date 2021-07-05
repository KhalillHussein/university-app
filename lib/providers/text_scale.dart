import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double initialScale = 1.0;

class TextScaleProvider with ChangeNotifier {
  static double _scaleFactor = initialScale;

  TextScaleProvider() {
    init();
  }

  double get scaleFactor => _scaleFactor;

  void setScaleFactor(double newFactor) {
    _scaleFactor = newFactor;
    notifyListeners();
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _scaleFactor = prefs.getDouble('scale') ?? initialScale;
    notifyListeners();
  }
}
