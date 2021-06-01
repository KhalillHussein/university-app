import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mtusiapp/ui/widgets/search.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../widgets/index.dart';
import '../../util/extensions.dart';

class TimetableTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableRepository>(
      builder: (ctx, model, _) => SimpleTab<TimetableRepository>(
        title: 'Расписание',
        fab: FloatingActionButton(
          tooltip: 'Поиск',
          onPressed: model.isLoaded || model.timetable.isNotEmpty
              ? () => showSearchTimetable(context, model)
              : null,
          child: const Icon(Icons.search),
        ),
        body: BigTip(
          title: Text(
            'Выберите свое расписание',
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).headline6,
            textScaleFactor: 0.95,
          ).scalable(),
          subtitle: Text(
            'Ваше расписание не определено. Воспользуйтесь поиском.',
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).subtitle1.copyWith(
                  color: Theme.of(context).textTheme.caption.color,
                ),
            textScaleFactor: 0.95,
          ).scalable(),
          child: const Icon(
            Icons.schedule,
          ),
        ),
      ),
    );
  }
}
