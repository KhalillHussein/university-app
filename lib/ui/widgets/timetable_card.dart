import 'package:auto_size_text/auto_size_text.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
      color: Theme.of(context).cardColor,
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
                          flex: 10,
                          child: AutoSizeText(
                            subject,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 1,
                            softWrap: true,
                            textScaleFactor: 0.9,
                          ),
                        ),
                        Spacer(),
                        Text(
                          aud,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildScheduleInfo(
                      icon: MdiIcons.accountTie,
                      context: context,
                      text: name,
                    ),
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
                  size: 18,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            TextSpan(
              text: text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(height: 1.3, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        textScaleFactor: 0.95,
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
