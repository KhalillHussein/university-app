import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(height: 1.3, fontWeight: FontWeight.w600),
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
                child: const Text(
                  'КОНТАКТНАЯ ИНФОРМАЦИЯ СКФ МТУСИ',
                  style: TextStyle(letterSpacing: 0.6),
                  textScaleFactor: 0.8,
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
          color: Theme.of(context).cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(2.0),
            onTap: item['url'] != null ? () => launchUrl(item['url']) : null,
            child: SizedBox(
              height: 70,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                      child: Icon(item['icon']),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['name'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.w600),
                            textScaleFactor: 0.85,
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: AutoSizeText(
                              item['desc'],
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    height: 1.2,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ];
  }
}
