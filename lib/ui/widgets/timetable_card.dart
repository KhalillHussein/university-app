import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

class TimetableCard extends StatelessWidget {
  final String id;
  final String lesson;
  final String aud;
  final String name;
  final String subject;
  final String subjectType;
  final String cafedra;

  const TimetableCard({
    @required this.cafedra,
    @required this.id,
    @required this.lesson,
    @required this.aud,
    @required this.name,
    @required this.subject,
    @required this.subjectType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        child: Row(
          children: [
            Text(
              lesson,
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).headline5,
            ),
            const SizedBox(width: 20),
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
                          text: cafedra,
                        ),
                        _buildBadge(context, subjectType),
                      ],
                    ),
                    Separator.spacer(space: 8),
                    SizedBox(
                      height: 25,
                      child: AutoSizeText(
                        subject,
                        style: GoogleFonts.rubikTextTheme(
                          Theme.of(context).textTheme,
                        ).bodyText2,
                        maxLines: 2,
                        softWrap: true,
                        textScaleFactor: 1.2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildScheduleInfo(
                          icon: MdiIcons.domain,
                          context: context,
                          text: aud,
                        ),
                        _buildScheduleInfo(
                          icon: MdiIcons.accountTie,
                          context: context,
                          text: name,
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

  Widget _buildBadge(BuildContext context, String subjectType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: subjectType.toLowerCase().contains('лек')
            ? Theme.of(context).brightness == Brightness.dark
                ? Color(0xFF2C9ED4)
                : Color(0xFF039BE5)
            : subjectType.toLowerCase().contains('пз')
                ? Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF89B3F7)
                    : Color(0xFF4285F4)
                : subjectType.toLowerCase().contains('лр')
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Color(0xFF4AB884)
                        : Color(0xFF009688)
                    : Theme.of(context).errorColor,
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
                            : Theme.of(context).errorColor,
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
            ),
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
      ),
    );
  }
}
