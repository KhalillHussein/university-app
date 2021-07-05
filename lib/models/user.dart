enum Positions { student, lecturer, admin, stuff, unauthorized }

class User {
  final String userId;
  final String token;
  final String userName;
  final String email;
  final String role;
  final String notificationToken;
  final String verification;
  final bool verified;

  User({
    this.userId,
    this.token,
    this.userName,
    this.email,
    this.role,
    this.notificationToken,
    this.verification,
    this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId:
          (json['user'] ?? const {})['_id'] ?? json['userId'] ?? json['_id'],
      token: json['token'],
      userName: (json['user'] ?? const {})['name'] ??
          json['username'] ??
          json['name'],
      email:
          (json['user'] ?? const {})['email'] ?? json['email'] ?? json['email'],
      role: (json['user'] ?? const {})['role'] ?? json['role'] ?? json['role'],
      notificationToken: json['notificationToken'],
      verification: json['verification'],
      verified: json['verified'],
    );
  }

  Positions getUserPosition() {
    switch (role) {
      case 'student':
        return Positions.student;
        break;
      case 'lecturer':
        return Positions.lecturer;
        break;
      case 'admin':
        return Positions.admin;
      case 'stuff':
        return Positions.stuff;
        break;
      default:
        return Positions.unauthorized;
        break;
    }
  }
}
