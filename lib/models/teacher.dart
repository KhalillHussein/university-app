import 'package:flutter/foundation.dart';

class Teacher {
  final int id;
  final String name;
  final String power;
  final String specification;
  final String photo;

  Teacher({
    @required this.id,
    @required this.name,
    @required this.power,
    @required this.specification,
    @required this.photo,
  });
}
