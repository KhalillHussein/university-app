import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:latlong/latlong.dart';

import '../../ui/widgets/header_map.dart';
import '../../util/doc.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: true,
        title: Text('Основные сведения'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverBar(
            header: MapHeader(LatLng(47.219186, 39.712502)),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        Doc.organizationText,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            height: 1.5,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  _buildCard(
                    context,
                    color: Color(0xFF4CAF50),
                    data: Doc.requisites,
                  ),
                  _buildCard(
                    context,
                    color: Color(0xFFFF9800),
                    data: Doc.schedule,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {Color color, String data}) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 8.0, color: color),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: MarkdownBody(
            selectable: true,
            data: data,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 13.0,
                height: 1.3,
              ),
            ),
            onTapLink: (link) => FlutterWebBrowser.openWebPage(
              url: link,
              androidToolbarColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SliverBar extends StatelessWidget {
  static const double heightRatio = 0.3;

  final Widget header;
  final num height;
  final List<Widget> actions;

  const SliverBar({
    this.header,
    this.height = heightRatio,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 0.0,
      expandedHeight: MediaQuery.of(context).size.height * height,
      automaticallyImplyLeading: false,
      actions: actions,
      //pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: header,
      ),
    );
  }
}
