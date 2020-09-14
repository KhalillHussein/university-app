// import 'package:community_material_icon/community_material_icon.dart';
// import 'package:flutter/material.dart';
//
// import 'cache_image.dart';
//
// class LecturerCard extends StatelessWidget {
//   final String id;
//   final String fullName;
//   final String email;
//   final String rank;
//   final String academicDegree;
//   final String academicRank;
//   final DateTime totalLengthOfService;
//   final DateTime lengthWorkOfSpeciality;
//   final String photo;
//   final List education;
//   final List qualification;
//   final List specialty;
//   final List trainings;
//   final List disciplinesTaught;
//   final List scientificInterests;
//
//   LecturerCard({
//     @required this.id,
//     @required this.fullName,
//     @required this.email,
//     @required this.rank,
//     @required this.academicDegree,
//     @required this.academicRank,
//     @required this.totalLengthOfService,
//     @required this.lengthWorkOfSpeciality,
//     @required this.photo,
//     @required this.education,
//     @required this.qualification,
//     @required this.specialty,
//     @required this.trainings,
//     @required this.disciplinesTaught,
//     @required this.scientificInterests,
//   });
//
//   Widget _buildTeacherInfo(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'СКФ МТУСИ',
//             style: TextStyle(fontSize: 11, letterSpacing: 1),
//           ),
//           Text(
//             fullName,
//             style: TextStyle(fontSize: 21),
//           ),
//           RichText(
//             text: TextSpan(
//               children: [
//                 WidgetSpan(
//                   child: const Icon(
//                     CommunityMaterialIcons.account_tie,
//                     size: 23,
//                   ),
//                 ),
//                 TextSpan(
//                   text: ' $rank',
//                   style: TextStyle(
//                     color: Theme.of(context).textTheme.bodyText1.color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           RichText(
//             text: TextSpan(
//               children: [
//                 WidgetSpan(
//                   child: const Icon(
//                     CommunityMaterialIcons.book_open,
//                     size: 23,
//                   ),
//                 ),
//                 TextSpan(
//                   text: ' $disciplinesTaught',
//                   style: TextStyle(
//                     color: Theme.of(context).textTheme.bodyText1.color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey, width: 0.1),
//         color: Theme.of(context).cardTheme.color,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 200,
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildTeacherInfo(context),
//                   CacheImage.teacher(url: photo),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 5.0),
//             child: FlatButton(
//               padding: const EdgeInsets.all(10),
//               onPressed: () {
//                 showDialog(
//                     context: context,
//                     builder: (ctx) => CustomDialog(
//                           title: '$fullName, $rank',
//                           description: {
//                             'Научная степень:': academicDegree,
//                             'Должность:': academicRank,
//                             'Образование:': education,
//                             'Дисциплины:': disciplinesTaught,
//                             'Стаж:': ((DateTime.now()
//                                         .difference(lengthWorkOfSpeciality)
//                                         .inDays) /
//                                     365)
//                                 .floor(),
//                           },
//                         ));
//               },
//               child: const Text(
//                 'ПОДРОБНЕЕ',
//                 style: TextStyle(letterSpacing: 0.9),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CustomDialog extends StatelessWidget {
//   final String title;
//   final Map<String, Object> description;
//
//   CustomDialog({
//     @required this.title,
//     @required this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: 15),
//             ListView.separated(
//               separatorBuilder: (context, index) => Divider(
//                 height: 1.0,
//               ),
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: description.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String key = description.keys.elementAt(index);
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           '$key',
//                           style: Theme.of(context).dialogTheme.contentTextStyle,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           '${description[key]}',
//                           style: Theme.of(context)
//                               .dialogTheme
//                               .contentTextStyle
//                               .copyWith(fontWeight: FontWeight.w400),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Map<String, Object> description;

  CustomDialog({
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),
            ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: description.length,
              itemBuilder: (BuildContext context, int index) {
                String key = description.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '$key',
                          style: Theme.of(context).dialogTheme.contentTextStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${description[key]}',
                          style: Theme.of(context)
                              .dialogTheme
                              .contentTextStyle
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
