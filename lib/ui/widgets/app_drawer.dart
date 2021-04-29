import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../providers/index.dart';
import '../../repositories/auth.dart';
import '../../util/index.dart';
import '../screens/index.dart';

class AppDrawer extends StatelessWidget {
  final List<Map<String, String>> kafedru = [
    {
      'name':
          'Коллектив кафедры инфокоммуникационных технологий и систем связи',
      'abbr': 'ИТСС',
    },
    {
      'name': 'Коллектив кафедры информатики и вычислительной техники',
      'abbr': 'ИВТ',
    },
    {
      'name': 'Коллектив кафедры общенаучной подготовки',
      'abbr': 'ОНП',
    },
    {
      'name': 'Коллектив отдела научно-исследовательской работы',
      'abbr': 'ОНИР',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isAuth = context.watch<AuthRepository>().isAuth;
    final Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        children: <Widget>[
          if (!isAuth) _buildDrawerHeader(context),
          if (isAuth)
            Separator.spacer(
              space: size.height * 0.15,
            ),
          Separator.divider(),
          _buildMainInfo(context, isAuth),
          const SizedBox(height: 10),
          Separator.divider(),
          _buildDownloadableResources(context),
          const SizedBox(height: 10),
          Separator.divider(),
          _buildExternalResources(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 75.0, left: 15, right: 30, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text('Авторизация',
                    style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  'Студент или преподаватель? Выполните вход для использования всех функций',
                  style:
                      Theme.of(context).textTheme.caption.copyWith(height: 1.4),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.loginVariant,
            color: Theme.of(context).accentColor,
          ),
          title: Transform.translate(
            offset: Offset(-15, 2),
            child: Text(
              'Войти',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ),
          onTap: () {
            context.read<NavigationProvider>().currentIndex = Tabs.auth.index;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildMainInfo(BuildContext context, [bool isAuth]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: Text(
            'Основные сведения',
            textAlign: TextAlign.start,
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).caption,
          ),
        ),
        _buildSection(
          context,
          label: 'Научно-педагогический состав',
          icon: MdiIcons.accountTie,
          color: Theme.of(context).accentIconTheme.color,
          children: [
            for (final item in kafedru)
              ListTile(
                title: Text(
                  item['name'],
                  maxLines: 3,
                  style: Theme.of(context).textTheme.caption,
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  LecturersScreen.route,
                  arguments: {'kafedra': item['abbr']},
                ),
              ),
          ],
        ),
        _buildSection(
          context,
          onTap: () => Navigator.of(context).pushNamed(PhoneBookScreen.route),
          label: 'Телефонный справочник',
          icon: MdiIcons.cardAccountPhone,
          color: Theme.of(context).accentIconTheme.color,
        ),
        if (isAuth)
          _buildSection(
            context,
            onTap: () => Navigator.of(context).pushNamed(InquiriesScreen.route),
            label: 'Заказ справок',
            icon: MdiIcons.fileDocumentEditOutline,
            color: Theme.of(context).accentIconTheme.color,
          ),
      ],
    );
  }

  Widget _buildDownloadableResources(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: Text(
            'Загружаемые ресурсы',
            textAlign: TextAlign.start,
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).caption,
          ),
        ),
        _buildSection(
          context,
          onTap: () =>
              showUrl('http://www.skf-mtusi.ru/files/info/docs/pps-20_21.pdf'),
          label: 'График консультаций ППС',
          icon: MdiIcons.download,
          color: Theme.of(context).accentIconTheme.color,
        ),
      ],
    );
  }

  Widget _buildExternalResources(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: Text(
            'Внешние ресурсы',
            textAlign: TextAlign.start,
            style: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ).caption,
          ),
        ),
        _buildSection(
          context,
          onTap: () => showUrl('http://www.skf-mtusi.ru/?page_id=659'),
          label: 'Методические материалы',
          icon: MdiIcons.openInNew,
          color: Theme.of(context).accentIconTheme.color,
        ),
        _buildSection(
          context,
          onTap: () => showUrl('http://skf-works.ru'),
          label: 'Портфолио',
          icon: MdiIcons.openInNew,
          color: Theme.of(context).accentIconTheme.color,
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    @required IconData icon,
    @required String label,
    VoidCallback onTap,
    @required Color color,
    List<Widget> children,
    Widget trailing,
  }) {
    return children != null
        ? Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(
                icon,
              ),
              childrenPadding: const EdgeInsets.only(bottom: 10, left: 55),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).accentColor.withOpacity(0.1)
                  : Colors.white10,
              title: Text(
                label,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: trailing,
              children: children,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            ),
            child: ListTile(
              leading: Icon(
                icon,
              ),
              title: Text(
                label,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: trailing,
              onTap: onTap,
            ),
          );
  }
}
