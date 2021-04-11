import 'package:flutter/foundation.dart';

class PhoneBook {
  final int id;
  final String fullName;
  final List<dynamic> department;
  final List<dynamic> post;
  final List<dynamic> phoneNumber;

  PhoneBook({
    @required this.id,
    @required this.fullName,
    @required this.department,
    @required this.post,
    @required this.phoneNumber,
  });

  factory PhoneBook.fromJson(Map<String, dynamic> json) {
    return PhoneBook(
      id: json['_id'],
      fullName: json['full_name'],
      department: json['department'],
      post: json['post'],
      phoneNumber: json['phone_number'],
    );
  }
}
