// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/lecturer_provider.dart';
// import 'lecturer_card.dart';
//
// class LecturerList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LecturerProvider>(
//       builder: (ctx, lecturerData, _) => ListView.builder(
//         itemCount: lecturerData.itemCount,
//         itemBuilder: (ctx, index) {
//           final lecturer = lecturerData.items[index];
//           return LecturerCard(
//             id: lecturer.id,
//             fullName: lecturer.fullName,
//             email: lecturer.email,
//             rank: lecturer.rank,
//             academicDegree: lecturer.academicDegree,
//             academicRank: lecturer.academicRank,
//             totalLengthOfService: lecturer.totalLengthOfService,
//             lengthWorkOfSpeciality: lecturer.lengthWorkOfSpeciality,
//             photo: lecturer.photo,
//             disciplinesTaught: lecturer.disciplinesTaught,
//             scientificInterests: lecturer.scientificInterests,
//             trainings: lecturer.trainings,
//             specialty: lecturer.specialty,
//             qualification: lecturer.qualification,
//             education: lecturer.education,
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/lecturer_provider.dart';
import '../../models/lecturer.dart';
import 'lecturer_card.dart';
import 'cache_image.dart';

class LecturerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LecturerProvider>(
      builder: (ctx, lecturerData, _) => ListView.builder(
        itemCount: lecturerData.lecturersCount,
        itemBuilder: _buildLecturerCard,
      ),
    );
  }

  Widget _buildLecturerCard(BuildContext context, int index) {
    return Consumer<LecturerProvider>(builder: (ctx, model, _) {
      final Lecturer lecturer = model.lecturers[index];
      return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.1),
          color: Theme.of(context).cardTheme.color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'СКФ МТУСИ',
                            style: TextStyle(fontSize: 11, letterSpacing: 1),
                          ),
                          Text(
                            lecturer.fullName,
                            style: TextStyle(fontSize: 21),
                          ),
                          _buildTeacherInfo(
                              context,
                              CommunityMaterialIcons.account_tie,
                              lecturer.rank),
                          _buildTeacherInfo(
                              context,
                              CommunityMaterialIcons.book_open,
                              lecturer.disciplinesTaught),
                        ],
                      ),
                    ),
                    CacheImage.teacher(url: lecturer.photo),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: FlatButton(
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => CustomDialog(
                      title: '${lecturer.fullName}, ${lecturer.rank}',
                      description: {
                        'Научная степень:': lecturer.academicDegree,
                        'Должность:': lecturer.academicRank,
                        'Образование:': lecturer.education,
                        'Дисциплины:': lecturer.disciplinesTaught,
                        'Стаж:': ((DateTime.now()
                                    .difference(lecturer.lengthWorkOfSpeciality)
                                    .inDays) /
                                365)
                            .floor(),
                      },
                    ),
                  );
                },
                child: const Text(
                  'ПОДРОБНЕЕ',
                  style: TextStyle(letterSpacing: 0.9),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTeacherInfo(BuildContext context, IconData icon, dynamic text) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(icon, size: 23),
          ),
          TextSpan(
            text: ' $text',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ],
      ),
    );
  }
}
