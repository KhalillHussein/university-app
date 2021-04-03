import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class LecturersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String kafedra = ModalRoute.of(context).settings.arguments;
    return BasicPage<LecturersRepository>(
      title: 'Коллектив $kafedra',
      body: _buildLecturerCard(context, kafedra),
    );
  }

  Widget _buildLecturerCard(BuildContext context, String kafedra) {
    return Consumer<LecturersRepository>(builder: (ctx, model, _) {
      return ListView.builder(
          itemCount: model.getByKafedra(kafedra).length,
          itemBuilder: (ctx, index) {
            final Lecturer lecturer = model.getByKafedra(kafedra)[index];
            return Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
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
                                  style:
                                      TextStyle(fontSize: 11, letterSpacing: 1),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  lecturer.fullName,
                                  style: TextStyle(fontSize: 21),
                                ),
                                const SizedBox(height: 5),
                                _buildTeacherInfo(
                                  context,
                                  MdiIcons.accountTie,
                                  lecturer.rank,
                                ),
                                Expanded(
                                  child: _buildTeacherInfo(
                                    context,
                                    MdiIcons.bookOpen,
                                    lecturer.disciplinesTaught.reduce(
                                        (value, element) =>
                                            value + ', ' + element),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          CacheImage.teacher(url: lecturer.photo),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(10),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CustomDialog(
                            title: '${lecturer.fullName}, ${lecturer.rank}',
                            description: {
                              'Научная степень:': lecturer.academicDegree,
                              'Должность:': lecturer.academicRank,
                              'Образование:': lecturer.education.reduce(
                                  (value, element) => value + ', ' + element),
                              'Дисциплины:': lecturer.disciplinesTaught.reduce(
                                  (value, element) => value + ', ' + element),
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
    });
  }

  Widget _buildTeacherInfo(BuildContext context, IconData icon, String text) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(icon, size: 23),
          ),
          TextSpan(
            text: '  $text',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      textScaleFactor: 0.8,
    );
  }
}
