import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/providers/index.dart';
import 'package:mtusiapp/repositories/auth.dart';
import 'package:mtusiapp/util/index.dart';
import 'package:provider/provider.dart';

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
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!isAuth) _buildDrawerHeader(context),
            if (isAuth) SizedBox(height: size.height * 0.15),
            const SizedBox(height: 10),
            const Divider(
              height: 1,
              thickness: 1.1,
            ),
            _buildMainInfo(context, isAuth),
            const SizedBox(height: 10),
            const Divider(
              height: 1,
              thickness: 1.1,
            ),
            _buildDownloadableResources(context),
            const SizedBox(height: 10),
            const Divider(
              height: 1,
              thickness: 1.1,
            ),
            _buildExternalResources(context),
          ],
        ),
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
                child: Text(
                  'Авторизация',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  'Студент или преподаватель? Выполните вход для использования всех функций',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(height: 1.4),
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
                  fontWeight: FontWeight.bold),
              textScaleFactor: 1.2,
            ),
          ),
          onTap: () {
            context.read<NavigationProvider>().currentIndex = Tabs.auth.index;
            context.select((value) => value.onTapToClose);
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
            textScaleFactor: 1.1,
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
                title: Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: AutoSizeText(
                    item['name'],
                    textScaleFactor: 0.8,
                    // style: GoogleFonts.rubikTextTheme(
                    //   Theme.of(context).textTheme,
                    // ).subtitle1,
                    maxLines: 3,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  Routes.lecturers,
                  arguments: item['abbr'],
                ),
              ),
          ],
        ),
        _buildSection(
          context,
          onTap: () => Navigator.of(context).pushNamed(Routes.phoneBook),
          label: 'Телефонный справочник',
          icon: MdiIcons.cardAccountPhone,
          color: Theme.of(context).accentIconTheme.color,
        ),
        if (isAuth)
          _buildSection(
            context,
            onTap: () => Navigator.of(context).pushNamed(Routes.inquiries),
            label: 'Заказ справок',
            icon: MdiIcons.fileDocumentEdit,
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
            textScaleFactor: 1.1,
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
            textScaleFactor: 1.1,
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
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: ExpansionTile(
                leading: Icon(
                  icon,
                  size: 24,
                ),
                childrenPadding: const EdgeInsets.only(bottom: 10),
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).accentColor.withOpacity(0.1)
                        : Colors.white10,
                title: AutoSizeText(
                  label,
                  style: GoogleFonts.rubikTextTheme(
                    Theme.of(context).textTheme,
                  ).bodyText1,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.1,
                ),
                trailing: trailing,
                children: children,
              ),
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
                size: 24,
              ),
              title: AutoSizeText(
                label,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).bodyText1,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.1,
              ),
              trailing: trailing,
              onTap: onTap,
            ),
          );
  }
}
