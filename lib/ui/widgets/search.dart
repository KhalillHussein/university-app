import 'package:flutter/material.dart';

import 'package:big_tip/big_tip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';
import 'package:search_page/search_page.dart';

import '../../repositories/index.dart';
import '../../util/extensions.dart';
import 'index.dart';

Future<String> showSearchTimetable(
    BuildContext context, TimetableRepository model) {
  return showSearch<String>(
    context: context,
    delegate: SearchPage<String>(
      items: [...model.groups, ...model.lecturers, ...model.aud],
      searchLabel: 'Поиск по расписанию',
      suggestion: Center(
        child: SingleChildScrollView(
          child: BigTip(
            title: Text(
              'Расписание занятий',
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).headline6,
              textScaleFactor: 0.95,
            ).scalable(),
            subtitle: Text(
              'Поиск по группе, преподавателю или аудитории',
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).subtitle1.copyWith(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
              textScaleFactor: 0.95,
            ).scalable(),
            child: const Icon(Icons.search),
          ),
        ),
      ),
      failure: Center(
        child: SingleChildScrollView(
          child: BigTip(
            title: Text(
              'Ой... Тут пусто',
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).headline6,
              textScaleFactor: 0.95,
            ).scalable(),
            subtitle: Text(
              'По вашему запросу ничего не найдено',
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).subtitle1.copyWith(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
              textScaleFactor: 0.95,
            ).scalable(),
            child: const Icon(Icons.sentiment_dissatisfied),
          ),
        ),
      ),
      filter: (category) => [category],
      builder: (record) => Column(
        children: [
          ListCell.icon(
              iconSize: 35,
              icon: model.getCategory(record) == Categories.lecturer
                  ? MdiIcons.accountTie
                  : model.getCategory(record) == Categories.auditory
                      ? MdiIcons.domain
                      : MdiIcons.accountGroup,
              title: record,
              subtitle: model.getCategory(record) == Categories.lecturer
                  ? 'Преподаватель'
                  : model.getCategory(record) == Categories.auditory
                      ? 'Аудитория'
                      : 'Группа',
              onTap: () async {
                model.setUserCategory(record);
                Navigator.pop(context);
              }),
          Separator.divider(indent: 70),
        ],
      ),
    ),
  );
}
