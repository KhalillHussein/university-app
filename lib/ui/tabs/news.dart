import 'package:big_tip/big_tip.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mtusiapp/models/index.dart';
import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';

import '../../repositories/index.dart';
import '../../repositories/news_create.dart';
import '../../ui/widgets/index.dart';
import '../../util/index.dart';

// class NewsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ReloadableTab<NewsRepository>(
//       title: 'Новости',
//       placeholder: NewsPlaceholder(),
//       body: Scrollbar(
//         thickness: 3.0,
//         child: Consumer<NewsRepository>(
//           builder: (ctx, model, _) => ScrollablePositionedList.builder(
//             addAutomaticKeepAlives: false,
//             itemCount:
//                 model.hasReachedMax() ? model.itemCount : model.itemCount + 1,
//             itemBuilder: (BuildContext context, int index) {
//               model.handleScrollWithIndex(index);
//               return index >= model.itemCount
//                   ? BottomLoader<NewsRepository>()
//                   : NewsCard(
//                       index,
//                       Key(model.news[index].id),
//                     );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final PagingController<int, News> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      context.read<NewsRepository>().pageIndex = pageKey;
      context.read<NewsRepository>().loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) => ReloadablePaginatedTab<News, NewsRepository>(
        title: 'Новости',
        placeholder: NewsPlaceholder(),
        onTryAgain: model.retryLastFailedRequest,
        pagingController: _pagingController..value = model.pagingState,
        itemBuilder: (context, item, index) => NewsCard(
          item,
          Key(item.id),
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return SimplePage(
//     actions: [
//       ThemeSwitchIcon(),
//       IconButton(
//         splashRadius: 20,
//         icon: const Icon(MdiIcons.cogOutline),
//         onPressed: () => Navigator.pushNamed(context, SettingsScreen.route),
//       ),
//     ],
//     title: 'Новости',
//     leading: IconButton(
//       splashRadius: 20,
//       tooltip: 'Меню',
//       icon: const Icon(MdiIcons.menu),
//       onPressed: Scaffold.of(context).openDrawer,
//     ),
//     body: Consumer<NewsRepository>(
//       builder: (ctx, model, _) => RawScrollbar(
//         interactive: true,
//         thickness: 3,
//         child: RefreshIndicator(
//           onRefresh: () => Future.sync(
//             () => model.refreshData(),
//           ),
//           child: PagedListView<int, News>(
//             pagingController: _pagingController..value = model.pagingState,
//             builderDelegate: PagedChildBuilderDelegate<News>(
//               itemBuilder: (context, item, index) => NewsCard(
//                 item,
//                 Key(item.id),
//               ),
//               firstPageProgressIndicatorBuilder: (_) => NewsPlaceholder(),
//               firstPageErrorIndicatorBuilder: (_) => ConnectionError(
//                 onTryAgain: () => model.refreshData(),
//               ),
//               newPageErrorIndicatorBuilder: (_) => PageErrorIndicator(
//                 error: _pagingController.error,
//                 onTryAgain: () => model.retryLastFailedRequest(),
//               ),
//               newPageProgressIndicatorBuilder: (_) => Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Center(
//                   child: SizedBox(
//                     width: 25,
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(
//                             Theme.of(context).textTheme.caption.color),
//                         strokeWidth: 5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
//
// /// Widget used to display a connection error message.
// /// It allows user to reload the page with a simple button.
// class ConnectionError extends StatelessWidget {
//   final VoidCallback onTryAgain;
//
//   const ConnectionError({this.onTryAgain});
//
//   @override
//   Widget build(BuildContext context) {
//     return BigTip(
//       title: Text(
//         'Что-то пошло не так',
//         style: GoogleFonts.rubikTextTheme(
//           Theme.of(context).textTheme,
//         ).headline6,
//       ).scalable(),
//       subtitle: Column(
//         children: [
//           Text(
//             'При загрузке данных произошла ошибка.\nПовторите попытку позже.',
//             textScaleFactor: 0.9,
//             style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
//                 .bodyText2
//                 .copyWith(height: 1.3),
//           ).scalable(),
//           Separator.spacer(),
//           TextButton(
//             onPressed: onTryAgain,
//             child: Text(
//               'ПОВТОРИТЬ',
//               style: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)
//                   .subtitle2
//                   .copyWith(
//                     color: Theme.of(context).accentColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//             ).scalable(),
//           ),
//         ],
//       ),
//       child: const Icon(Icons.cloud_off),
//     );
//   }
// }
//
// class PageErrorIndicator extends StatelessWidget {
//   final String error;
//   final VoidCallback onTryAgain;
//
//   const PageErrorIndicator({
//     this.error,
//     this.onTryAgain,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTryAgain,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           children: [
//             Text(
//               'Что-то пошло не так. Повторите попытку.',
//             ).scalable(),
//             Separator.spacer(space: 6),
//             const Icon(
//               Icons.refresh,
//               size: 18,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Theme.of(context).errorColor,
//           content: Row(
//             children: [
//               Icon(
//                 Icons.error,
//                 color: Theme.of(context).primaryColor,
//               ),
//               Separator.spacer(),
//               Expanded(
//                 child: Text(
//                   message,
//                   softWrap: true,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           duration: const Duration(seconds: 1),
//         ),
//       );
//   }
// }

class NewsCard extends StatelessWidget {
  final News item;

  const NewsCard(this.item, Key key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNewsHeader(context, item.getDate, item.id),
          Separator.spacer(space: 15),
          Head(item.title),
          if (item.images.isNotEmpty) BodyImages(item.images),
          if (item.images.isEmpty) Separator.spacer(space: 10),
          Body(
            id: item.id,
            introText: item.introText,
            fullText: item.fullText,
            views: item.views,
            shareImage: item.images.isNotEmpty ? item.images.first : '',
            shareTitle: item.title,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsHeader(BuildContext context, String date, [String id]) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
      child: Consumer<AuthRepository>(
        builder: (ctx, model, _) => Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: k24dp,
                  child: ClipOval(
                      child: Image.asset(
                    'assets/images/avatar.png',
                  )),
                ),
                Separator.spacer(space: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'СКФ МТУСИ',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black87
                                    : Colors.white.withOpacity(0.9),
                          ),
                      textScaleFactor: 1.1,
                    ).scalable(),
                    Separator.spacer(space: 3),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.caption,
                      textScaleFactor: 1.15,
                    ).scalable(),
                  ],
                ),
              ],
            ),
            if (model.getUserPosition() == Positions.admin)
              Positioned(
                top: -15,
                right: 0,
                child: IconButton(
                  splashRadius: 15,
                  tooltip: 'Удалить',
                  icon: Icon(
                    MdiIcons.trashCanOutline,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () => _showDialog(context, id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: const Text(
          'Удалить эту новость?',
        ).scalable(),
        content: Text(
          'Новость будет удалена из списка без возможности восстановления.',
          style:
              GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).bodyText2,
        ).scalable(),
        actions: <Widget>[
          TextButton(
            style:
                TextButton.styleFrom(primary: Theme.of(context).disabledColor),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'ОТМЕНА',
            ).scalable(),
          ),
          Consumer2<NewsRepository, NewsCreateRepository>(
            builder: (ctx, model, model2, _) => TextButton(
              onPressed: () async {
                await model2.deleteData(id);
                if (model2.loadingFailed) {
                  _showSnackBar(context, model2.errorMessage);
                }
                model.deleteItem(id);
                Navigator.of(ctx).pop();
                // model.refreshData();
              },
              child: const Text(
                'ОК',
              ).scalable(),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).errorColor,
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Theme.of(context).primaryColor,
              ),
              Separator.spacer(),
              Expanded(
                child: Text(
                  message,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

// class NewsCard extends StatelessWidget {
//   final int index;
//
//   const NewsCard(this.index, Key key) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       margin: const EdgeInsets.all(10.0),
//       child: Consumer<NewsRepository>(builder: (ctx, model, _) {
//         final newsItem = model.news[index];
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _buildNewsHeader(context, newsItem.getDate, newsItem.id),
//             Separator.spacer(space: 15),
//             Head(newsItem.title),
//             if (newsItem.images.isNotEmpty) BodyImages(newsItem.images),
//             if (newsItem.images.isEmpty) Separator.spacer(space: 10),
//             Body(
//               id: newsItem.id,
//               introText: newsItem.introText,
//               fullText: newsItem.fullText,
//               views: newsItem.views,
//               shareImage:
//                   newsItem.images.isNotEmpty ? newsItem.images.first : '',
//               shareTitle: newsItem.title,
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildNewsHeader(BuildContext context, String date, [String id]) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0, left: 15.0),
//       child: Consumer<AuthRepository>(
//         builder: (ctx, model, _) => Stack(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor: k24dp,
//                   child: ClipOval(
//                       child: Image.asset(
//                     'assets/images/avatar.png',
//                   )),
//                 ),
//                 Separator.spacer(space: 15),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'СКФ МТУСИ',
//                       style: Theme.of(context).textTheme.bodyText1.copyWith(
//                             color:
//                                 Theme.of(context).brightness == Brightness.light
//                                     ? Colors.black87
//                                     : Colors.white.withOpacity(0.9),
//                           ),
//                       textScaleFactor: 1.1,
//                     ).scalable(),
//                     Separator.spacer(space: 3),
//                     Text(
//                       date,
//                       style: Theme.of(context).textTheme.caption,
//                       textScaleFactor: 1.15,
//                     ).scalable(),
//                   ],
//                 ),
//               ],
//             ),
//             if (model.getUserPosition() == Positions.admin)
//               Positioned(
//                 top: -15,
//                 right: 0,
//                 child: IconButton(
//                   splashRadius: 15,
//                   tooltip: 'Удалить',
//                   icon: Icon(
//                     MdiIcons.trashCanOutline,
//                     color: Theme.of(context).errorColor,
//                   ),
//                   onPressed: () => _showDialog(context, id),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showDialog(BuildContext context, String id) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: Theme.of(context).appBarTheme.color,
//         title: const Text(
//           'Удалить эту новость?',
//         ).scalable(),
//         content: Text(
//           'Новость будет удалена из списка без возможности восстановления.',
//           style:
//               GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).bodyText2,
//         ).scalable(),
//         actions: <Widget>[
//           TextButton(
//             style:
//                 TextButton.styleFrom(primary: Theme.of(context).disabledColor),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: const Text(
//               'ОТМЕНА',
//             ).scalable(),
//           ),
//           Consumer2<NewsRepository, NewsCreateRepository>(
//             builder: (ctx, model, model2, _) => TextButton(
//               onPressed: () async {
//                 await model2.deleteData(id);
//                 if (model2.postingFailed) {
//                   _showSnackBar(context, model.errorMessage);
//                 }
//                 model.deleteItem(id);
//                 Navigator.of(ctx).pop();
//                 // model.refreshData();
//               },
//               child: const Text(
//                 'ОК',
//               ).scalable(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Theme.of(context).errorColor,
//           content: Row(
//             children: [
//               Icon(
//                 Icons.error,
//                 color: Theme.of(context).primaryColor,
//               ),
//               Separator.spacer(),
//               Expanded(
//                 child: Text(
//                   message,
//                   softWrap: true,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//   }
// }
