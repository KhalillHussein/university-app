import 'package:flutter/foundation.dart';

class Lecturer {
  final int id;
  final String fullName;
  final String email;
  final String rank;
  final String kafedra;
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
    @required this.kafedra,
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
      kafedra: json['kafedra'],
      academicDegree: json['academic_degree'],
      academicRank: json['academic_rank'],
      totalLengthOfService: DateTime.parse(json['total_length_of_service']),
      lengthWorkOfSpeciality: DateTime.parse(json['length_work_of_speciality']),
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
      ((DateTime.now().difference(lengthWorkOfSpeciality).inDays) / 365)
          .floor()
          .toString();

  String get getTotalLengthOfService =>
      ((DateTime.now().difference(totalLengthOfService).inDays) / 365)
          .floor()
          .toString();
}
