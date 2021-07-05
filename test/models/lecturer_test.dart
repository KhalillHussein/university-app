import 'package:mtusiapp/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Lecturer', () {
    test('is correctly generated from a JSON', () {
      expect(
        Lecturer.fromJson(const {
          "_id": 1,
          "full_name": "Иванов Иван Иваныч",
          "email": "ivanov@mail.ru",
          "rank": "доцент",
          "kafedra": "ИВТ",
          "academic_rank": "доцент",
          "academic_degree": "доцент",
          "total_length_of_service": "2000-06-20",
          "length_work_of_speciality": "2006-06-20",
          "photo": "http://www.skf-mtusi.ru/images/ruk/Zhukovskiy.jpg",
          "education": ["РИНХ", "РГЭУ"],
          "qualification": ["Тест в тесте", "Тест в тесте"],
          "specialty": ["Специальность тест", "Специальность тест"],
          "trainings": ["Алкатель лусент", "МТУСИ СКФ"],
          "disciplines_taught": ["Математика", "Геометрия"],
          "scientific_interests": ["Математика", "Программирование"]
        }),
        Lecturer(
          id: 1,
          fullName: 'Иванов Иван Иваныч',
          email: 'ivanov@mail.ru',
          rank: 'доцент',
          kafedra: 'ИВТ',
          academicRank: 'доцент',
          academicDegree: 'доцент',
          totalLengthOfService: DateTime(2000, 6, 20),
          lengthWorkOfSpeciality: DateTime(2006, 6, 20),
          photo: 'http://www.skf-mtusi.ru/images/ruk/Zhukovskiy.jpg',
          education: ['РИНХ', 'РГЭУ'],
          qualification: ['Тест в тесте', 'Тест в тесте'],
          specialty: ['Специальность тест', 'Специальность тест'],
          trainings: ['Алкатель лусент', 'МТУСИ СКФ'],
          disciplinesTaught: ['Математика', 'Геометрия'],
          scientificInterests: ['Математика', 'Программирование'],
        ),
      );
    });
  });
}
