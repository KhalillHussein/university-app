import 'package:flutter/foundation.dart';

enum DocType { eDoc, realDoc }

class RadioProvider with ChangeNotifier {
  DocType _doc = DocType.realDoc;

  DocType get doc => _doc;

  set doc(DocType newDoc) {
    _doc = newDoc;
    notifyListeners();
  }
}
