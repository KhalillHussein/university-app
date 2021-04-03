import 'package:flutter/foundation.dart';

class User {
  final String userId;
  final String token;
  final String userName;
  final String group;
  final String email;
  final String role;

  User({
    @required this.userId,
    @required this.token,
    @required this.userName,
    @required this.group,
    @required this.email,
    @required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: (json['user'] ?? const {})['_id'] ?? json['userId'],
      token: json['token'],
      userName: (json['user'] ?? const {})['name'] ?? json['username'],
      group: 'ДИ-11',
      email: (json['user'] ?? const {})['email'] ?? json['email'],
      role: (json['user'] ?? const {})['role'] ?? json['role'],
    );
  }
}
