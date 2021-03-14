import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SelectableText(
          Doc.organizationText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.3),
          scrollPhysics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, left: 6),
              child: const Text(
                'КОНТАКТНАЯ ИНФОРМАЦИЯ СКФ МТУСИ',
                style: TextStyle(letterSpacing: 1.0, fontSize: 13),
              ),
            ),
            Column(children: _listRequisites(context)),
          ],
        ),
      ),
    );
  }

  List<Widget> _listRequisites(BuildContext context) {
    final List<Widget> requisites = [];
    for (final Map item in Doc.info) {
      requisites.add(
        Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 5.0),
                  child: Icon(item['icon']),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: Theme.of(context).textTheme.bodyText2,
                        textScaleFactor: 0.85,
                        // style: TextStyle(
                        //     fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        item['desc'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.caption,
                        textScaleFactor: 1.1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return requisites;
  }
}
