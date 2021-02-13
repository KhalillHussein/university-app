import 'package:flutter/foundation.dart';

class User {
  final String userId;
  final String token;
  final String userName;
  final String email;
  final String role;

  User({
    @required this.userId,
    @required this.token,
    @required this.userName,
    @required this.email,
    @required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user']['_id'] ?? json['userId'],
      token: json['token'],
      userName: json['user']['name'] ?? json['username'],
      email: json['user']['email'] ?? json['email'],
      role: json['user']['role'] ?? json['role'],
    );
  }
}
