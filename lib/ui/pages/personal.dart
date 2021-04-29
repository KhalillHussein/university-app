import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:row_collection/row_collection.dart';

import '../../models/index.dart';
import '../widgets/index.dart';

class PersonalPage extends StatelessWidget {
  final Lecturer _lecturer;

  const PersonalPage(this._lecturer);

  static const route = '/personal_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('О преподавателе'),
            pinned: true,
          ),
          SliverBar(
            header: _buildLecturerHeader(context),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainInfoCard(context),
                    Separator.spacer(),
                    _buildSpecialityCard(context),
                    Separator.spacer(),
                    _buildDisciplinesTaughtCard(context),
                    Separator.spacer(),
                    _buildTrainingsCard(context),
                    Separator.spacer(),
                    _buildScientificInterestsCard(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: CacheImage.lecturer(
                _lecturer.photo,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withOpacity(0.1),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _lecturer.kafedra,
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500),
                    textScaleFactor: 0.9,
                  ),
                ),
                Separator.spacer(space: 5),
                AutoSizeText(
                  _lecturer.fullName,
                  style: Theme.of(context).textTheme.headline5,
                  maxLines: 2,
                ),
                Spacer(flex: 2),
                _buildLecturerInfo(context, 'Должность:', _lecturer.rank),
                Spacer(),
                _buildLecturerInfo(
                    context, 'Ученая степень:', _lecturer.academicDegree),
                Spacer(),
                _buildLecturerInfo(
                    context, 'Ученое звание:', _lecturer.academicRank),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerInfo(BuildContext context, section, String label) {
    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$section ',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          TextSpan(
              text: label,
              style: Theme.of(context).textTheme.caption.copyWith(height: 1.4)),
        ],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    return CardCell.body(
      context,
      title: 'Основные сведения',
      child: RowLayout(children: <Widget>[
        RowText(
          'Образование',
          _lecturer.qualification
              .reduce((value, element) => '$value, $element'),
        ),
        Separator.divider(),
        RowText(
          'Общий стаж',
          'с ${_lecturer.totalLengthOfService.year} года',
        ),
        RowText(
          'Стаж работы по специальности',
          'с ${_lecturer.lengthWorkOfSpeciality.year} года',
        ),
      ]),
    );
  }

  Widget _buildSpecialityCard(BuildContext context) {
    return CardCell.body(
      context,
      title: 'Специальность',
      child: RowLayout(children: <Widget>[
        for (int i = 0; i < _lecturer.specialty.length; i++)
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Text(
                    i > _lecturer.specialty.length - 1
                        ? _lecturer.specialty[_lecturer.specialty.length - 1]
                        : _lecturer.specialty[i],
                  ),
                ),
                TextSpan(
                    text: i > _lecturer.education.length - 1
                        ? ' (${_lecturer.education[_lecturer.education.length - 1]})'
                        : ' (${_lecturer.education[i]})',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
      ]),
    );
  }

  Widget _buildDisciplinesTaughtCard(BuildContext context) {
    return CardCell.body(
      context,
      title: 'Преподаваемые дисциплины',
      child: ExpandText(
        _lecturer.disciplinesTaught
            .reduce((value, element) => '$value, $element'),
        collapsedHint: 'Развернуть',
        expandedHint: 'Свернуть',
        style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
        maxLines: 4,
      ),
    );
  }

  Widget _buildTrainingsCard(BuildContext context) {
    return CardCell.body(
      context,
      title: 'Повышение квалификации',
      child: ExpandText(
        _lecturer.trainings.reduce((value, element) => '$value\n$element'),
        maxLines: 4,
        style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
        collapsedHint: 'Развернуть',
        expandedHint: 'Свернуть',
      ),
    );
  }

  Widget _buildScientificInterestsCard(BuildContext context) {
    return CardCell.body(
      context,
      title: 'Научные интересы',
      child: RowLayout(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _lecturer.scientificInterests
                  .reduce((value, element) => '$value, $element'),
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
            ),
          ]),
    );
  }
}
