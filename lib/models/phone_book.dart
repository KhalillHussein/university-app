class PhoneBook {
  final int id;
  final String fullName;
  final List<dynamic> department;
  final List<dynamic> post;
  final List<dynamic> phoneNumber;

  PhoneBook({
    this.id,
    this.fullName,
    this.department,
    this.post,
    this.phoneNumber,
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
