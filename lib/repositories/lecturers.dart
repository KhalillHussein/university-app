import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/lecturer.dart';
import '../util/url.dart';
import 'base.dart';

/// Repository that holds lecturers data.
class LecturersRepository extends BaseRepository {
  List<Lecturer> _lecturers;

  @override
  Future<void> loadData() async {
    try {
      final response = await http.get(Url.lecturersAllUrl);
      final responseData = json.decode(response.body);
      _lecturers = [for (final item in responseData) Lecturer.fromJson(item)];
      finishLoading();
    } catch (_) {
      receivedError();
    }
  }

  List<Lecturer> get lecturers => _lecturers;

  int get itemCount => _lecturers?.length;
}
