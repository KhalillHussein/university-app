import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';
import 'package:search_page/search_page.dart';

import '../../repositories/index.dart';
import '../widgets/index.dart';

class TimetableTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableRepository>(
      builder: (ctx, model, _) => DefaultTabController(
        length: 3,
        child: ReloadableSimplePage<TimetableRepository>.tabs(
          title: 'Расписание',
          leadingCallBack: Scaffold.of(context).openDrawer,
          fab: FloatingActionButton(
            tooltip: 'Поиск',
            onPressed: model.isLoaded || model.list.isNotEmpty
                ? () => showSearch(
                      context: context,
                      delegate: SearchPage<Map>(
                        items: model.searchCategories(),
                        searchLabel: 'Поиск по расписанию',
                        suggestion: BigTip(
                          title: Text(
                            'Расписание занятий',
                            style: GoogleFonts.rubikTextTheme(
                              Theme.of(context).textTheme,
                            ).headline6,
                          ),
                          subtitle: Text(
                            'Поиск по группе, преподавателю или аудитории',
                            style: GoogleFonts.rubikTextTheme(
                              Theme.of(context).textTheme,
                            ).subtitle1.copyWith(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                          ),
                          child: Icon(Icons.search),
                        ),
                        failure: BigTip(
                          title: Text(
                            'Ой... Тут пусто',
                            style: GoogleFonts.rubikTextTheme(
                              Theme.of(context).textTheme,
                            ).headline6,
                          ),
                          subtitle: Text(
                            'По вашему запросу ничего не найдено',
                            style: GoogleFonts.rubikTextTheme(
                              Theme.of(context).textTheme,
                            ).subtitle1.copyWith(
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                          ),
                          child: const Icon(Icons.sentiment_dissatisfied),
                        ),
                        filter: (category) => [category['name']],
                        builder: (record) => Column(
                          children: [
                            ListCell.icon(
                                icon: record['icon'],
                                iconSize: 35,
                                title: record['name'],
                                subtitle: record['group'],
                                onTap: () {
                                  Navigator.pop(context);
                                  model.setUserCategory(record['name']);
                                }
                                //     Navigator.pushReplacementNamed(
                                //   context,
                                //   TimetableScreen.route,
                                //   arguments: {
                                //     'timetableList': model.getBy(record['name']),
                                //     'category': record['category']
                                //   },
                                // ),
                                ),
                            Separator.divider(indent: 70),
                          ],
                        ),
                      ),
                    )
                : null,
            child: const Icon(Icons.search),
          ),
          body: BigTip(
            title: Text(
              'Выберите свое расписание',
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).headline6,
            ),
            subtitle: Text(
              'Ваше расписание не определено, воспользуйтесь поиском',
              style: GoogleFonts.rubikTextTheme(
                Theme.of(context).textTheme,
              ).subtitle1.copyWith(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
            ),
            child: const Icon(Icons.schedule),
          ),
        ),
      ),
    );
  }
}
