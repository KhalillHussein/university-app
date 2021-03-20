import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildDrawerHeader(context),
            const SizedBox(height: 20),
            _buildSection(
              context,
              label: 'Кафедры',
              icon: MdiIcons.accountTieOutline,
              color: Theme.of(context).iconTheme.color,
              children: [
                ListTile(
                  title: Text(
                    'Инфокоммуникационных технологий и систем связи',
                    textScaleFactor: 0.9,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Информатики и вычислительной техники',
                    textScaleFactor: 0.9,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Общенаучной подготовки',
                    textScaleFactor: 0.9,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Отдел научно-исследовательской работы',
                    textScaleFactor: 0.9,
                  ),
                  onTap: () {},
                ),
              ],
            ),
            _buildSection(
              context,
              onTap: () {},
              label: 'График консультаций ППС',
              icon: MdiIcons.calendarClockOutline,
              color: Theme.of(context).iconTheme.color,
            ),
            _buildSection(
              context,
              onTap: () {},
              label: 'Телефонный справочник',
              icon: MdiIcons.cardAccountPhoneOutline,
              color: Theme.of(context).iconTheme.color,
            ),
            _buildSection(
              context,
              onTap: () {},
              label: 'Заказ справок',
              icon: MdiIcons.fileDocumentEditOutline,
              color: Theme.of(context).iconTheme.color,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Divider(
                height: 1,
              ),
            ),
            _buildSection(
              context,
              onTap: () {},
              label: 'Методические материалы',
              icon: MdiIcons.openInNew,
              color: Theme.of(context).iconTheme.color,
            ),
            _buildSection(
              context,
              onTap: () {},
              label: 'Портфолио',
              icon: MdiIcons.openInNew,
              color: Theme.of(context).iconTheme.color,
            ),
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
              leading: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              backgroundColor: Theme.of(context).cardTheme.color,
              childrenPadding: EdgeInsets.only(left: 42),
              title: Transform.translate(
                offset: Offset(-15, 0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: color, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
              ),
              trailing: trailing,
              children: children,
            ),
          )
        : ListTile(
            leading: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            title: Transform.translate(
              offset: Offset(-15, 0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: color, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
            ),
            trailing: trailing,
            onTap: onTap,
          );
  }
}
