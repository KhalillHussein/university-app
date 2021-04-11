import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) => ReloadableScreen<NewsRepository>(
        body: Scrollbar(
          thickness: 3.0,
          child: ScrollablePositionedList.builder(
            addAutomaticKeepAlives: false,
            itemCount:
                model.hasReachedMax() ? model.itemCount : model.itemCount + 1,
            itemBuilder: (BuildContext context, int index) {
              model.handleScrollWithIndex(index);
              return index >= model.itemCount
                  ? BottomLoader<NewsRepository>()
                  : _buildNewsCard(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNewsHeader(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueGrey.withOpacity(0.2),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'СКФ МТУСИ',
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).bodyText1,
                textScaleFactor: 1.2,
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: GoogleFonts.rubikTextTheme(
                  Theme.of(context).textTheme,
                ).caption,
                textScaleFactor: 1.2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, int index) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) {
        final News news = model.news[index];
        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildNewsHeader(context, news.getDate),
              ),
              Head(news.title),
              if (news.images.isNotEmpty) BodyImages(news.images),
              if (news.images.isEmpty) const SizedBox(height: 10),
              Body(
                id: news.id,
                introText: news.introText,
                fullText: news.fullText,
                views: news.views,
              ),
            ],
          ),
        );
      },
    );
  }
}
