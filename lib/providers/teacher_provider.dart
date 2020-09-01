import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/teacher.dart';

class TeacherProvider with ChangeNotifier {
  List<Teacher> _items = [];

  List<Teacher> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> fetchAndSetResult() async {
    const String url =
        'https://firebasestorage.googleapis.com/v0/b/my-flutter-f53db.appspot.com/o/teacher.json?alt=media&token=0e07886f-21ab-4b6f-9d7e-ace229c3fe64';
    try {
      final response = await http.get(url);
      final List<Teacher> teachers = [];
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      responseData.forEach((teacher) {
        teachers.add(
          Teacher(
            id: teacher['id'],
            name: teacher['name'],
            power: teacher['power'],
            specification: teacher['specification'],
            photo: teacher['photo'],
          ),
        );
        _items = teachers;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }
}
