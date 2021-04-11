import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class LecturersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String kafedra = ModalRoute.of(context).settings.arguments;
    return ReloadableSimplePage<LecturersRepository>(
      title: 'Коллектив $kafedra',
      body: _buildLecturerCard(context, kafedra),
    );
  }

  Widget _buildLecturerCard(BuildContext context, String kafedra) {
    return Consumer<LecturersRepository>(builder: (ctx, model, _) {
      return ListView.separated(
          separatorBuilder: (ctx, index) => Divider(height: 1, indent: 80),
          itemCount: model.getByKafedra(kafedra).length,
          itemBuilder: (ctx, index) {
            final Lecturer lecturer = model.getByKafedra(kafedra)[index];
            return ListTile(
              onTap: () {},
              // open(context, url: lecturer.photo, title: lecturer.fullName),
              leading: CircleAvatar(
                radius: 23,
                backgroundColor: Colors.transparent,
                foregroundImage: NetworkImage(lecturer.photo),
                child: Icon(
                  MdiIcons.accountCircle,
                  color: Colors.white24,
                  size: 45,
                ),
              ),
              title: Text(
                lecturer.fullName,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).bodyText1,
                textScaleFactor: 1.2,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(right: 45.0),
                child: Text(
                  lecturer.academicRank,
                  style: GoogleFonts.rubikTextTheme(
                    Theme.of(context).textTheme,
                  ).caption,
                  textScaleFactor: 1.1,
                ),
              ),
            );
            // return Container(
            //   margin: const EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Theme.of(context).dividerColor),
            //     color: Theme.of(context).cardColor,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(
            //         height: 200,
            //         child: Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Expanded(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       'СКФ МТУСИ',
            //                       style: GoogleFonts.rubikTextTheme(
            //                         Theme.of(context).textTheme,
            //                       ).overline,
            //                       textScaleFactor: 1.1,
            //                     ),
            //                     const SizedBox(height: 5),
            //                     Text(
            //                       lecturer.fullName,
            //                       style: GoogleFonts.rubikTextTheme(
            //                         Theme.of(context).textTheme,
            //                       ).bodyText2,
            //                       textScaleFactor: 1.5,
            //                     ),
            //                     const SizedBox(height: 5),
            //                     _buildTeacherInfo(
            //                       context,
            //                       MdiIcons.accountTie,
            //                       lecturer.rank,
            //                     ),
            //                     Expanded(
            //                       child: _buildTeacherInfo(
            //                         context,
            //                         MdiIcons.bookOpen,
            //                         lecturer.disciplinesTaught.reduce(
            //                             (value, element) =>
            //                                 value + ', ' + element),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               const SizedBox(width: 15),
            //               CacheImage.teacher(url: lecturer.photo),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 5.0),
            //         child: TextButton(
            //           onPressed: () {
            //             showDialog(
            //               context: context,
            //               builder: (ctx) => CustomDialog(
            //                 title: '${lecturer.fullName}, ${lecturer.rank}',
            //                 description: {
            //                   'Научная степень:': lecturer.academicDegree,
            //                   'Должность:': lecturer.academicRank,
            //                   'Образование:': lecturer.education.reduce(
            //                       (value, element) => value + ', ' + element),
            //                   'Дисциплины:': lecturer.disciplinesTaught.reduce(
            //                       (value, element) => value + ', ' + element),
            //                   'Стаж:': lecturer.getLengthOfSpeciality,
            //                 },
            //               ),
            //             );
            //           },
            //           child: const Text(
            //             'ПОДРОБНЕЕ',
            //             style: TextStyle(letterSpacing: 0.9),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          });
    });
  }

  void open(BuildContext context, {String url, String title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalPage(url, title),
      ),
    );
  }

  // Widget _buildTeacherInfo(BuildContext context, IconData icon, String text) {
  //   return RichText(
  //     text: TextSpan(
  //       children: [
  //         WidgetSpan(
  //           child: Icon(
  //             icon,
  //             size: 23,
  //           ),
  //         ),
  //         TextSpan(
  //           text: '  $text',
  //           style: GoogleFonts.rubikTextTheme(
  //             Theme.of(context).textTheme,
  //           ).bodyText2.copyWith(height: 1.4, fontWeight: FontWeight.w400),
  //         ),
  //       ],
  //     ),
  //     maxLines: 4,
  //     overflow: TextOverflow.ellipsis,
  //     textScaleFactor: 0.9,
  //   );
  // }
}

class PersonalPage extends StatelessWidget {
  final String url;
  final String title;

  const PersonalPage(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverBar(
          header: CacheImage.teacher(
            url: url,
          ),
          title: title,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          height: 1.5,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom sliver app bar used in Sliver views.
/// It collapses when user scrolls down.
class SliverBar extends StatelessWidget {
  static const double heightRatio = 0.6;

  final String title;
  final Widget header;
  final num height;
  final List<Widget> actions;

  const SliverBar({
    this.title,
    this.header,
    this.height = heightRatio,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * height,
      actions: actions,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Using title constraining, because Flutter doesn't do this automatically.
        // Open issue: [https://github.com/flutter/flutter/issues/14227]
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.55,
          ),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            maxLines: 1,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w600,
              shadows: <Shadow>[
                Shadow(
                  color: Theme.of(context).primaryColor,
                  offset: Offset(0, 0),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        background: header,
      ),
    );
  }
}
