import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  final int id;
  final DateTime date;
  final int couple;
  final String lesson;
  final String type;
  final String teacher;
  final String room;

  const ScheduleCard({
    this.id,
    @required this.date,
    @required this.couple,
    @required this.lesson,
    @required this.type,
    @required this.teacher,
    @required this.room,
  });

  Widget _buildScheduleInfo(
      {BuildContext context, String text, IconData icon}) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              size: 18,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text('$couple', style: TextStyle(fontSize: 21)),
          Text(
            'пара',
            style: TextStyle(fontSize: 13),
          ),
          Text(
            DateFormat('hh:mm').format(date),
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).appBarTheme.color,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        trailing: Text(
          type,
          style:
              TextStyle(fontSize: 13, color: Theme.of(context).iconTheme.color),
        ),
        leading: _buildLeading(context),
        title: Text(
          lesson,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 4),
            _buildScheduleInfo(
              icon: CommunityMaterialIcons.account_tie,
              context: context,
              text: teacher,
            ),
            const SizedBox(height: 4),
            _buildScheduleInfo(
              icon: CommunityMaterialIcons.map_marker,
              context: context,
              text: room,
            ),
          ],
        ),
      ),
    );
  }
}
