import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TimetableCard extends StatelessWidget {
  final String id;
  final String lesson;
  final String aud;
  final String name;
  final String subject;
  final String subjectType;

  const TimetableCard({
    this.id,
    @required this.lesson,
    @required this.aud,
    @required this.name,
    @required this.subject,
    @required this.subjectType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
      child: Row(
        children: [
          // _buildLeading(context),
          // const SizedBox(width: 10),
          // SizedBox(
          //   height: 60,
          //   child: VerticalDivider(
          //     thickness: 2,
          //     // width: 1,
          //   ),
          // ),
          // const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 15),
                _buildTitle(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 10),
                      _buildScheduleInfo(
                        icon: MdiIcons.accountTie,
                        context: context,
                        text: name,
                      ),
                      const SizedBox(height: 10),
                      _buildScheduleInfo(
                        icon: MdiIcons.mapMarker,
                        context: context,
                        text: aud,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
          ),
          padding: EdgeInsets.all(5.0),
          child: Text(
            lesson,
            maxLines: 5,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Text(subjectType, style: Theme.of(context).textTheme.bodyText2),
      ],
    );

    //   RichText(
    //   text: TextSpan(
    //     children: [
    //       WidgetSpan(
    //         child: Container(
    //           width: 50,
    //           decoration: BoxDecoration(
    //               color: Theme.of(context).accentColor,
    //               borderRadius: const BorderRadius.only(
    //                 topRight: Radius.circular(40.0),
    //                 bottomRight: Radius.circular(40.0),
    //               )),
    //           padding: EdgeInsets.all(5.0),
    //           child: Text(
    //             '$lesson',
    //             maxLines: 5,
    //             style: TextStyle(
    //               fontSize: 15,
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ),
    //       TextSpan(
    //           text: subjectType, style: Theme.of(context).textTheme.bodyText2),
    //     ],
    //   ),
    // );
  }

  Widget _buildScheduleInfo(
      {BuildContext context, String text, IconData icon}) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                icon,
                size: 24,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              color: Theme.of(context).primaryIconTheme.color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(right: 15.0),
      margin: const EdgeInsets.only(left: 10.0),
      // decoration: BoxDecoration(
      //   border: Border(
      //     right: BorderSide(color: Theme.of(context).dividerColor),
      //   ),
      // ),
      child: Text(
        lesson,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
      ),
    );
  }
}
