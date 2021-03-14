import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildDrawerHeader(context),
          ListTile(
            leading: Icon(
              MdiIcons.formatListBulleted,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Transform.translate(
              offset: Offset(-18, 2),
              child: Text(
                'Разделы',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              MdiIcons.fileDocumentEditOutline,
              size: 28,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Transform.translate(
              offset: Offset(-18, 2),
              child: Text(
                'Заказ справок и документов',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 75.0, left: 15, right: 30, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Авторизация',
                textScaleFactor: 1.4,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Откройте доступ ко всем функциям приложения',
                style: TextStyle(fontWeight: FontWeight.w400, height: 1.4),
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
            offset: Offset(-18, 2),
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

    //   Padding(
    //   padding: const EdgeInsets.only(top: 40.0, left: 15.0, bottom: 10.0),
    //   child: Text(
    //     'Сведения об образовательной организации',
    //     style: TextStyle(
    //       fontSize: 20,
    //       color: Theme.of(context).textTheme.headline6.color,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );
  }
}
