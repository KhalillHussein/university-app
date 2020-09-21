import 'dart:convert';

import 'package:http/http.dart' as http;

import '../util/url.dart';
import '../models/lecturer.dart';
import 'base.dart';

/// Repository that holds lecturers data.
class LecturersRepository extends BaseRepository {
  List<Lecturer> _lecturers = [];

  List<Lecturer> get lecturers {
    return [..._lecturers];
  }

  int get itemCount {
    return _lecturers.length;
  }

  @override
  Future<void> loadData() async {
    print('trying fetch lecturers..');
    try {
      final response = await http.get(Url.lecturersAllUrl);
      final responseData = json.decode(response.body);
      _lecturers = [for (final item in responseData) Lecturer.fromJson(item)];
      finishLoading();
    } catch (_) {
      receivedError();
    }
  }
}
