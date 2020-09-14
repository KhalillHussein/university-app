import 'package:flutter/foundation.dart';

class Lecturer {
  final String id;
  final String fullName;
  final String email;
  final String rank;
  final String academicDegree;
  final String academicRank;
  final DateTime totalLengthOfService;
  final DateTime lengthWorkOfSpeciality;
  final String photo;
  final List education;
  final List qualification;
  final List specialty;
  final List trainings;
  final List disciplinesTaught;
  final List scientificInterests;

  Lecturer({
    @required this.id,
    @required this.fullName,
    @required this.email,
    @required this.rank,
    @required this.academicDegree,
    @required this.academicRank,
    @required this.totalLengthOfService,
    @required this.lengthWorkOfSpeciality,
    @required this.photo,
    @required this.education,
    @required this.qualification,
    @required this.specialty,
    @required this.trainings,
    @required this.disciplinesTaught,
    @required this.scientificInterests,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: json['_id'],
      fullName: json['full_name'],
      email: json['email'],
      rank: json['rank'],
      academicDegree: json['academic_degree'],
      academicRank: json['academic_rank'],
      totalLengthOfService:
          DateTime(int.parse(json['total_length_of_service']), 01, 01),
      lengthWorkOfSpeciality:
          DateTime(int.parse(json['length_work_of_speciality']), 01, 01),
      photo: json['photo'],
      disciplinesTaught: json['disciplines_taught'],
      scientificInterests: json['scientific_interests'],
      trainings: json['trainings'],
      specialty: json['specialty'],
      qualification: json['qualification'],
      education: json['education'],
    );
  }

  String get getLengthOfSpeciality =>
      DateTime.now().difference(lengthWorkOfSpeciality).inDays.toString();
}
