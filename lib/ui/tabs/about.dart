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
                  style: TextStyle(letterSpacing: 0.8, fontSize: 14),
                ),
              ),
            ),
            Column(children: _listRequisites(context)),
          ],
        ),
      ),
    );
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontWeight: FontWeight.w600),
                        textScaleFactor: 0.85,
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
    ];
  }
}
