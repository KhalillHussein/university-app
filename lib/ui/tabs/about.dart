import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/index.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAboutCard(context),
          _buildCardBody(context),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SelectableText(
          Doc.organizationText,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ).subtitle2.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white70,
              ),
          textScaleFactor: 1.1,
          scrollPhysics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
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
                ),
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
      for (final Map item in Doc.info)
        Card(
          elevation: 2,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : k04dp,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: ListTile(
            leading: SizedBox(
                height: double.infinity,
                child: Icon(
                  item['icon'],
                  size: 25,
                )),
            title: Transform.translate(
              offset: Offset(-13, 0),
              child: Text(
                item['name'],
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).bodyText1,
                textScaleFactor: 1,
              ),
            ),
            subtitle: Transform.translate(
              offset: Offset(-13, 0),
              child: Text(
                item['desc'],
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).caption,
                textScaleFactor: 1,
              ),
            ),
            onTap: item['url'] != null ? () => launchUrl(item['url']) : null,
          ),
        ),
    ];
  }
}
