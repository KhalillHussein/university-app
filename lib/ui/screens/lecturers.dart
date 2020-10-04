import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lecturer.dart';
import '../../repositories/lecturers.dart';
import '../../ui/widgets/cache_image.dart';
import '../../ui/widgets/custom_dialog.dart';
import '../../ui/widgets/custom_page.dart';

class LecturersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LecturersRepository>(
      builder: (ctx, model, _) => BasicPage<LecturersRepository>(
        title: 'Преподаватели',
        body: ListView.builder(
          itemCount: model.itemCount,
          itemBuilder: _buildLecturerCard,
        ),
      ),
    );
  }

  Widget _buildLecturerCard(BuildContext context, int index) {
    return Consumer<LecturersRepository>(builder: (ctx, model, _) {
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
            SizedBox(
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
                            lecturer.rank,
                          ),
                          _buildTeacherInfo(
                            context,
                            CommunityMaterialIcons.book_open,
                            lecturer.disciplinesTaught,
                          ),
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
                        'Стаж:': lecturer.getLengthOfSpeciality,
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
