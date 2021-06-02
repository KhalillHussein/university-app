import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../providers/index.dart';
import '../../repositories/auth.dart';
import '../../util/index.dart';
import '../screens/index.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = context.read<AuthRepository>();
    final Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Scrollbar(
        thickness: 3.0,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Separator.divider(),
            if (!userData.isAuth) _buildDrawerHeader(context, size),
            if (userData.isAuth) SizedBox(height: size.height * 0.2),
            Separator.divider(),
            _buildMainInfo(context),
            if (userData.getUserPosition() == Positions.student)
              _buildAdditional(context),
            _buildDownloadableResources(context),
            _buildExternalResources(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.08),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 30, bottom: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text('Авторизация',
                        style: Theme.of(context).textTheme.headline6)
                    .scalable(),
              ),
              Separator.spacer(space: 10),
              Flexible(
                child: Text(
                  'Студент или преподаватель? Выполните вход для использования всех функций',
                  style:
                      Theme.of(context).textTheme.caption.copyWith(height: 1.4),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                ).scalable(),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.loginVariant,
            color: Theme.of(context).accentColor,
          ),
          visualDensity: VisualDensity.comfortable,
          title: Transform.translate(
            offset: Offset(-15, 2),
            child: Text(
              'Войти',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ).scalable(),
          ),
          onTap: () {
            context.read<NavigationProvider>().currentIndex = Tabs.auth.index;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildSectionHead(BuildContext context, {String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
            color:
                Theme.of(context).textTheme.bodyText1.color.withOpacity(0.7)),
        textScaleFactor: 0.9,
      ).scalable(),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHead(context, title: 'Основные сведения'),
        _buildSection(
          context,
          label: 'Научно-педагогический состав',
          icon: MdiIcons.accountTie,
          children: [
            for (final item in kafedruSections)
              ListTile(
                title: Text(
                  item['name'],
                  maxLines: 3,
                  style: Theme.of(context).textTheme.caption,
                ).scalable(),
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
        ),
      ],
    );
  }

  Widget _buildAdditional(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHead(context, title: 'Для студента'),
        _buildSection(
          context,
          onTap: () => Navigator.of(context).pushNamed(InquiriesScreen.route),
          label: 'Заказ справок',
          icon: MdiIcons.fileDocumentEdit,
        ),
      ],
    );
  }

  Widget _buildDownloadableResources(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHead(context, title: 'Загружаемые ресурсы'),
        _buildSection(
          context,
          onTap: () =>
              showUrl('http://www.skf-mtusi.ru/files/info/docs/pps-20_21.pdf'),
          label: 'График консультаций ППС',
          icon: MdiIcons.download,
        ),
      ],
    );
  }

  Widget _buildExternalResources(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHead(context, title: 'Внешние ресурсы'),
        _buildSection(
          context,
          onTap: () => showUrl('http://www.skf-mtusi.ru/?page_id=659'),
          label: 'Методические материалы',
          icon: MdiIcons.openInNew,
        ),
        _buildSection(
          context,
          onTap: () => showUrl('http://skf-works.ru'),
          label: 'Портфолио',
          icon: MdiIcons.openInNew,
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    @required IconData icon,
    @required String label,
    VoidCallback onTap,
    List<Widget> children,
    Widget trailing,
  }) {
    return children != null
        ? Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(
                icon,
                size: 20,
                color: Theme.of(context).textTheme.caption.color,
              ),
              childrenPadding: const EdgeInsets.only(bottom: 10, left: 46),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).accentColor.withOpacity(0.1)
                  : Colors.white10,
              title: Transform.translate(
                offset: Offset(-10, 0),
                child: Text(
                  label,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.9),
                      ),
                ).scalable(),
              ),
              trailing: trailing,
              children: children,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ListTile(
              minLeadingWidth: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              visualDensity: VisualDensity.comfortable,
              leading: Icon(
                icon,
                size: 20,
                color: Theme.of(context).textTheme.caption.color,
              ),
              title: Text(
                label,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.9),
                    ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ).scalable(),
              trailing: trailing,
              onTap: onTap,
            ),
          );
  }
}
