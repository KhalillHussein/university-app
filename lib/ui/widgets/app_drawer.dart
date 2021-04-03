import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/repositories/auth.dart';
import 'package:mtusiapp/util/index.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
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
                  textScaleFactor: 1.4,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  'Откройте доступ ко всем функциям приложения',
                  style: TextStyle(fontWeight: FontWeight.w400, height: 1.4),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.exitToApp,
            color: Theme.of(context).accentColor,
          ),
          title: Transform.translate(
            offset: Offset(-15, 2),
            child: Text(
              'Войти',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Theme.of(context).accentColor),
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMainInfo(BuildContext context, [bool isAuth]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            'Основные сведения',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        _buildSection(
          context,
          label: 'Научно-педагогический состав',
          icon: MdiIcons.accountTieOutline,
          color: Theme.of(context).accentIconTheme.color,
          children: [
            for (final item in kafedru)
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: AutoSizeText(
                    item['name'],
                    textScaleFactor: 0.8,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w400),
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
          onTap: () {},
          label: 'Телефонный справочник',
          icon: MdiIcons.cardAccountPhoneOutline,
          color: Theme.of(context).accentIconTheme.color,
        ),
        if (isAuth)
          _buildSection(
            context,
            onTap: () => Navigator.of(context).pushNamed(Routes.inquiries),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            'Загружаемые ресурсы',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        _buildSection(
          context,
          onTap: () =>
              showUrl('http://www.skf-mtusi.ru/files/info/docs/pps-20_21.pdf'),
          label: 'График консультаций ППС',
          icon: MdiIcons.downloadOutline,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            'Внешние ресурсы',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1,
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
        ? ExpansionTile(
            leading: Icon(
              icon,
              size: 23,
              color: Theme.of(context).iconTheme.color,
            ),
            // backgroundColor: Theme.of(context).cardTheme.color,
            title: Transform.translate(
              offset: Offset(-15, 0),
              child: AutoSizeText(
                label,
                style: Theme.of(context).textTheme.bodyText1,
                textScaleFactor: 0.95,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            trailing: trailing,
            children: children,
          )
        : ListTile(
            leading: Icon(
              icon,
              size: 23,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Transform.translate(
              offset: Offset(-15, 0),
              child: AutoSizeText(
                label,
                style: Theme.of(context).textTheme.bodyText1,
                textScaleFactor: 0.95,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            trailing: trailing,
            onTap: onTap,
          );
  }
}
