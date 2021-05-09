import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';

class LecturersScreen extends StatelessWidget {
  final String kafedra;

  const LecturersScreen(this.kafedra);

  static const route = '/lecturers';

  @override
  Widget build(BuildContext context) {
    return ReloadableSimplePage<LecturersRepository>(
      placeholder: LecturersPlaceholder(),
      title: 'Коллектив $kafedra',
      body: _buildLecturerCard(context, kafedra),
    );
  }

  Widget _buildLecturerCard(BuildContext context, String kafedra) {
    return Consumer<LecturersRepository>(builder: (ctx, model, _) {
      final List<Lecturer> lecturers = model.getByKafedra(kafedra);
      return ListView.separated(
          separatorBuilder: (ctx, index) => Separator.divider(indent: 80),
          itemCount: lecturers.length,
          itemBuilder: (ctx, index) {
            final Lecturer lecturer = lecturers[index];
            return ListCell(
              onTap: () => Navigator.pushNamed(
                context,
                PersonalPage.route,
                arguments: {'name': lecturer.fullName},
              ),
              leading: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                child: CacheImage.avatar(
                  lecturer.photo,
                ),
              ),
              title: lecturer.fullName,
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                color: Theme.of(context).textTheme.caption.color,
              ),
              subtitle: lecturer.rank,
            );
          });
    });
  }
}
