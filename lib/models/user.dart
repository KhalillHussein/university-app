class User {
  final String userId;
  final String token;
  final String userName;
  final String group;
  final String email;
  final String role;

  User({
    this.userId,
    this.token,
    this.userName,
    this.group,
    this.email,
    this.role,
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
