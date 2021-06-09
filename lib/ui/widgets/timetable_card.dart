import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../util/index.dart';

class TimetableCard extends StatelessWidget {
  final String lessonNumber;
  final String title;
  final String header;
  final String subtitle;
  final String subjectType;
  final String trailing;
  final IconData trailingIcon;
  final IconData subtitleIcon;

  const TimetableCard({
    Key key,
    this.trailingIcon,
    this.subtitleIcon,
    @required this.lessonNumber,
    @required this.title,
    @required this.header,
    @required this.subtitle,
    @required this.subjectType,
    @required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        child: Row(
          children: [
            SizedBox(
              width: 35,
              child: Text(
                lessonNumber,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).headline5.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.caption.color),
              ).scalable(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildScheduleInfo(
                          icon: MdiIcons.school,
                          context: context,
                          text: header,
                        ),
                        _buildBadge(context, subjectType),
                      ],
                    ),
                    Separator.spacer(space: 4),
                    Text(
                      title,
                      style: GoogleFonts.rubikTextTheme(
                        Theme.of(context).textTheme,
                      ).bodyText2,
                      maxLines: 2,
                      softWrap: true,
                      textScaleFactor: 1.2,
                    ).scalable(),
                    Separator.spacer(space: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildScheduleInfo(
                          icon: subtitleIcon ?? MdiIcons.domain,
                          context: context,
                          text: subtitle,
                        ),
                        _buildScheduleInfo(
                          icon: trailingIcon ?? MdiIcons.accountTie,
                          context: context,
                          text: trailing,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(BuildContext context, {String subjectType}) {
    if (subjectType.toLowerCase().contains('лек')) {
      return Theme.of(context).colorScheme.lecture;
    }
    if (subjectType.toLowerCase().contains('пз')) {
      return Theme.of(context).colorScheme.practice;
    }
    if (subjectType.toLowerCase().contains('лр')) {
      return Theme.of(context).colorScheme.laboratory;
    }
    if (subjectType.toLowerCase().contains('кон')) {
      return Theme.of(context).colorScheme.consultation;
    }
    return Theme.of(context).colorScheme.exam;
  }

  Widget _buildBadge(BuildContext context, String subjectType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: getColor(context, subjectType: subjectType),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                subjectType.toLowerCase().contains('лек')
                    ? MdiIcons.bookOpenOutline
                    : subjectType.toLowerCase().contains('пз')
                        ? MdiIcons.pencil
                        : subjectType.toLowerCase().contains('лр')
                            ? MdiIcons.flaskOutline
                            : subjectType.toLowerCase().contains('кон')
                                ? MdiIcons.forumOutline
                                : MdiIcons.alertOctagramOutline,
                size: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            Text(
              subjectType,
              style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                  ),
              textScaleFactor: 1.1,
            ).scalable(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleInfo(
      {BuildContext context, String text, IconData icon}) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
            TextSpan(
              text: text,
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).caption,
            ),
          ],
        ),
        textScaleFactor: 1.15,
      ).scalable(),
    );
  }
}
