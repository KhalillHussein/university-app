import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';
import '../pages/index.dart';

class LecturersScreen extends StatelessWidget {
  final String kafedra;

  const LecturersScreen(this.kafedra);

  static const route = '/lecturers';

  @override
  Widget build(BuildContext context) {
    return ReloadableSimplePage<LecturersRepository>.lecturers(
      title: 'Коллектив $kafedra',
      body: _buildLecturerCard(context, kafedra),
    );
  }

  Widget _buildLecturerCard(BuildContext context, String kafedra) {
    return Consumer<LecturersRepository>(builder: (ctx, model, _) {
      return ListView.separated(
          separatorBuilder: (ctx, index) => Separator.divider(indent: 80),
          itemCount: model.getByKafedra(kafedra).length,
          itemBuilder: (ctx, index) {
            final Lecturer lecturer = model.getByKafedra(kafedra)[index];
            return ListTile(
              onTap: () => Navigator.pushNamed(
                context,
                PersonalPage.route,
                arguments: {'object': lecturer},
              ),
              leading: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                child: CacheImage.avatar(
                  lecturer.photo,
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(right: 40),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Text(
                    lecturer.fullName,
                    maxLines: 1,
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).bodyText1,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
              ),
              subtitle: Text(
                lecturer.rank,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          });
    });
  }
}
