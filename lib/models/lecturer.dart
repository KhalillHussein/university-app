import 'package:equatable/equatable.dart';

class Lecturer extends Equatable {
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

  const Lecturer({
    this.id,
    this.fullName,
    this.email,
    this.rank,
    this.kafedra,
    this.academicDegree,
    this.academicRank,
    this.totalLengthOfService,
    this.lengthWorkOfSpeciality,
    this.photo,
    this.education,
    this.qualification,
    this.specialty,
    this.trainings,
    this.disciplinesTaught,
    this.scientificInterests,
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

  @override
  List<Object> get props => [
        id,
        fullName,
        email,
        rank,
        kafedra,
        academicDegree,
        academicRank,
        totalLengthOfService,
        lengthWorkOfSpeciality,
        photo,
        education,
        qualification,
        specialty,
        trainings,
        disciplinesTaught,
        scientificInterests,
      ];
}
