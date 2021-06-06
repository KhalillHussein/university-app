import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/index.dart';
import '../screens/index.dart';
import '../widgets/index.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'О нас',
      leading: IconButton(
        splashRadius: 20,
        icon: const Icon(MdiIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      actions: [
        ThemeSwitchIcon(),
        IconButton(
          splashRadius: 20,
          icon: const Icon(MdiIcons.cogOutline),
          onPressed: () => Navigator.pushNamed(context, SettingsScreen.route),
        ),
      ],
      body: RawScrollbar(
        thickness: 3,
        child: ListView(
          children: [
            _buildAboutCard(context),
            _buildCardBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SelectableText(
          organizationText,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).subtitle2.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white70,
              ),
          scrollPhysics: NeverScrollableScrollPhysics(),
        ).scalable(),
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, left: 6, top: 10.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'КОНТАКТНАЯ ИНФОРМАЦИЯ СКФ МТУСИ',
                  style: GoogleFonts.rubikTextTheme(
                    Theme.of(context).textTheme,
                  ).overline,
                  textScaleFactor: 1.1,
                ).scalable(),
              ),
            ),
            Column(children: _listRequisites(context)),
          ],
        ),
      ),
    );
  }

  Future<void> launchUrl(String url) async {
    if (url.contains('http')) {
      showUrl(url);
    } else {
      if (await canLaunch(url)) {
        launch(url);
      } else {
        throw "Could not launch $url";
      }
    }
  }

  List<Widget> _listRequisites(BuildContext context) {
    return [
      for (final Map item in info)
        Card(
          elevation: 2.0,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : k08dp,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: InkWell(
            onTap: item['url'] != null ? () => launchUrl(item['url']) : null,
            borderRadius: BorderRadius.circular(3.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                  ),
                  Separator.spacer(space: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: GoogleFonts.rubikTextTheme(
                            Theme.of(context).textTheme,
                          ).bodyText2,
                        ).scalable(),
                        Separator.spacer(space: 3),
                        Text(
                          item['desc'],
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(height: 1.2, letterSpacing: 0.3),
                        ).scalable(),
                      ],
                    ),
                  ),
                  if (item['url'] != null)
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 28,
                      color: Theme.of(context).disabledColor,
                    ),
                ],
              ),
            ),
          ),
        ),
    ];
  }
}
