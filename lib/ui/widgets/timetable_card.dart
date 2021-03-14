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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        child: Row(
          children: [
            _buildLeading(context),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            subject,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                    ),
                            maxLines: 4,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          aud,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    _buildScheduleInfo(
                      icon: MdiIcons.accountTie,
                      context: context,
                      text: name,
                    ),
                    const SizedBox(height: 2),
                    _buildScheduleInfo(
                      icon: MdiIcons.tagMultiple,
                      context: context,
                      text: subjectType,
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
                size: 18,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              color: Theme.of(context).primaryIconTheme.color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Text(
      lesson,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
    );
  }
}
