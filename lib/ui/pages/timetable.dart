import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/helpers/repositories/index.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GroupList();
  }
}

class _GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicPageNoScaffoldWithMessage<TimetableDbRepository,
        TimetableRepository>(
      body: Consumer<TimetableRepository>(
        builder: (ctx, model, _) => ListView.separated(
          itemBuilder: (ctx, index) => ListTile(
            leading: Icon(
              MdiIcons.accountGroup,
              size: 35,
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
                    builder: (context) => _Timetable(model.groups[index])),
              );
            },
          ),
          separatorBuilder: (ctx, index) => Divider(
            height: 1,
            endIndent: 15,
            indent: 70,
          ),
          itemCount: model.groups.length,
        ),
      ),
    );
  }
}

class _Timetable extends StatelessWidget {
  final String groupName;

  const _Timetable(this.groupName);

  @override
  Widget build(BuildContext context) {
    return BasicPage<TimetableRepository>(
      title: 'Группа: $groupName',
      body: Consumer<TimetableRepository>(
        builder: (ctx, model, _) => _buildListView(
          context,
          model.getByGroup(groupName),
        ),
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
                //color: Colors.black,
                height: 36,
              )),
        ),
        Text(
          '${toBeginningOfSentenceCase(DateFormat.EEEE('Ru').format(date))}, ${DateFormat.MMMMd('Ru').format(date)}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                //  color: Colors.black,
                height: 36,
              )),
        ),
      ]),
    );
  }
}
