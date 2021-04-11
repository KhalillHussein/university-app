import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReloadableScreen<TimetableRepository>(
      body: Consumer<TimetableRepository>(
        builder: (ctx, model, _) => ListView.separated(
          itemBuilder: (ctx, index) => ListTile(
            leading: Icon(
              MdiIcons.accountGroup,
              size: 30,
            ),
            title: Text(model.groups[index],
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 17)),
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15,
            ),
            subtitle: Text(
              'Курс ${model.course[index]}',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReloadableSimplePage<TimetableRepository>(
                            title: model.groups[index],
                            body: TimetableList(model.groups[index]))),
              );
            },
          ),
          separatorBuilder: (ctx, index) => Divider(
            height: 1,
            thickness: 1.1,
            endIndent: 15,
            indent: 70,
          ),
          itemCount: model.groups.length,
        ),
      ),
    );
  }
}

class TimetableList extends StatelessWidget {
  final String groupName;

  const TimetableList(this.groupName);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableRepository>(
      builder: (ctx, model, _) => _buildListView(
        context,
        model.getByGroup(groupName),
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Timetable> timetable) {
    return GroupedListView<Timetable, DateTime>(
      floatingHeader: true,
      addAutomaticKeepAlives: false,
      elements: timetable,
      groupBy: (element) =>
          DateTime(element.date.year, element.date.month, element.date.day),
      groupSeparatorBuilder: (groupByValue) =>
          _buildSeparator(context, groupByValue),
      shrinkWrap: true,
      indexedItemBuilder: (context, schedule, index) => TimetableCard(
        id: schedule.id,
        lesson: schedule.lesson,
        subject: schedule.subject,
        subjectType: schedule.subjectType,
        name: schedule.name,
        aud: schedule.aud,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              thickness: 1.2,
              height: 36,
            ),
          ),
        ),
        Text(
          '${toBeginningOfSentenceCase(DateFormat.EEEE('Ru').format(date))}, ${DateFormat.MMMMd('Ru').format(date)}',
          textAlign: TextAlign.center,
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).caption,
          textScaleFactor: 1.2,
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                thickness: 1.2,
                height: 36,
              )),
        ),
      ]),
    );
  }
}
