import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../util/url.dart';
import '../models/lecturer.dart';

class LecturerProvider with ChangeNotifier {
  List<Lecturer> _lecturers = [];

  List<Lecturer> get lecturers {
    return [..._lecturers];
  }

  int get lecturersCount {
    return _lecturers.length;
  }

  Future<void> fetchAndSetResult() async {
    try {
      final response = await http.get(Url.lecturersAllUrl);
      final responseData = json.decode(response.body);
      _lecturers = [for (final item in responseData) Lecturer.fromJson(item)];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
