// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/news.dart';
// import '../../repositories/news.dart';
// import '../../ui/widgets/custom_page.dart';
// import '../../ui/widgets/news_card.dart';
//
// class NewsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NewsRepository>(builder: (ctx, model, _) => NewsList(model)
//
//         //     ListViewPage<NewsRepository>(
//         //   itemCount: model.itemCount,
//         //   buildFunction: _buildNewsCard,
//         // ),
//         );
//   }
//
//   Widget _buildNewsHeader(String date) {
//     return ListTile(
//       leading: CircleAvatar(),
//       title: const Text(
//         'СКФ МТУСИ',
//         style: TextStyle(fontWeight: FontWeight.w600),
//       ),
//       subtitle: Text(date),
//     );
//   }
//
//   Widget _buildNewsCard(BuildContext context, int index) {
//     return Consumer<NewsRepository>(
//       builder: (ctx, model, _) {
//         final News news = model.news[index];
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4),
//           ),
//           elevation: 2,
//           margin: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               _buildNewsHeader(news.getDate),
//               Head(news.title),
//               if (news.images.isNotEmpty) BodyImages(news.images),
//               Body(
//                 id: news.id,
//                 introText: news.introText,
//                 fullText: news.fullText,
//                 views: news.views,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class NewsList extends StatefulWidget {
//   final NewsRepository newsRepository;
//
//   const NewsList(this.newsRepository);
//
//   @override
//   _NewsListState createState() => _NewsListState();
// }
//
// class _NewsListState extends State<NewsList> {
//   final _scrollController = ScrollController();
//   final _scrollThreshold = 200.0;
//   int _pageIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.position.pixels;
//     if (maxScroll - currentScroll <= _scrollThreshold) {
//       if (!widget.newsRepository.hasReachedMax) {
//         widget.newsRepository.loadData(pageIndex: ++_pageIndex);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.newsRepository.isLoading
//         ? CircularProgressIndicator()
//         : widget.newsRepository.loadingFailed
//             ? Text('Error')
//             : ListView.builder(
//                 itemBuilder: (BuildContext context, int index) {
//                   return index >= widget.newsRepository.itemCount
//                       ? BottomLoader()
//                       : _buildNewsCard(context, index);
//                 },
//                 itemCount: widget.newsRepository.hasReachedMax
//                     ? widget.newsRepository.itemCount
//                     : widget.newsRepository.itemCount + 1,
//                 controller: _scrollController,
//               );
//   }
//
//   Widget _buildNewsHeader(String date) {
//     return ListTile(
//       leading: CircleAvatar(),
//       title: const Text(
//         'СКФ МТУСИ',
//         style: TextStyle(fontWeight: FontWeight.w600),
//       ),
//       subtitle: Text(date),
//     );
//   }
//
//   Widget _buildNewsCard(BuildContext context, int index) {
//     return Consumer<NewsRepository>(
//       builder: (ctx, model, _) {
//         final News news = model.news[index];
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4),
//           ),
//           elevation: 2,
//           margin: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               _buildNewsHeader(news.getDate),
//               Head(news.title),
//               if (news.images.isNotEmpty) BodyImages(news.images),
//               Body(
//                 id: news.id,
//                 introText: news.introText,
//                 fullText: news.fullText,
//                 views: news.views,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class BottomLoader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       child: Center(
//         child: SizedBox(
//           width: 33,
//           height: 33,
//           child: CircularProgressIndicator(
//             strokeWidth: 1.5,
//           ),
//         ),
//       ),
//     );
//   }
// }

//NEW REALIZATION

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/news.dart';
// import '../../repositories/news.dart';
// import '../../ui/widgets/custom_page.dart';
// import '../../ui/widgets/news_card.dart';
//
// class NewsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NewsRepository>(
//       builder: (ctx, model, _) => NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification notification) {
//           _handleScrollNotification(notification, model);
//           return false;
//         },
//         child: ListViewPage<NewsRepository>(
//           buildFunction: (BuildContext context, int index) {
//             return index >= model.itemCount
//                 ? BottomLoader()
//                 : _buildNewsCard(context, index);
//           },
//           itemCount:
//               model.hasReachedMax() ? model.itemCount : model.itemCount + 1,
//         ),
//       ),
//     );
//   }
//
//   void _handleScrollNotification(
//       ScrollNotification notification, NewsRepository model) {
//     if (notification is ScrollEndNotification) {
//       if (notification.metrics.pixels >=
//           notification.metrics.maxScrollExtent * 0.8) {
//         if (!model.hasReachedMax()) {
//           model.nextPage();
//         }
//       }
//     }
//   }
//
//   Widget _buildNewsHeader(String date) {
//     return SizedBox(
//       height: 38,
//       child: ListTile(
//         leading: CircleAvatar(),
//         title: const Text(
//           'СКФ МТУСИ',
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//         ),
//         subtitle: Text(
//           date,
//           style: TextStyle(fontSize: 14),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNewsCard(BuildContext context, int index) {
//     return Consumer<NewsRepository>(
//       builder: (ctx, model, _) {
//         final News news = model.news[index];
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4),
//           ),
//           elevation: 1,
//           margin: const EdgeInsets.all(10.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 35),
//                 child: _buildNewsHeader(news.getDate),
//               ),
//               Head(news.title),
//               if (news.images.isNotEmpty) BodyImages(news.images),
//               if (news.images.isEmpty) const SizedBox(height: 10),
//               Body(
//                 id: news.id,
//                 introText: news.introText,
//                 fullText: news.fullText,
//                 views: news.views,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class BottomLoader extends StatefulWidget {
//   @override
//   _BottomLoaderState createState() => _BottomLoaderState();
// }
//
// class _BottomLoaderState extends State<BottomLoader>
//     with SingleTickerProviderStateMixin {
//   Animation<double> animation;
//   AnimationController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         duration: const Duration(milliseconds: 600), vsync: this);
//     animation = Tween<double>(begin: 0, end: 2).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Curves.easeInCubic,
//       ),
//     );
//     animation.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         controller.reverse();
//       } else if (status == AnimationStatus.dismissed) {
//         controller.forward();
//       }
//     });
//     controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//       elevation: 1,
//       margin: EdgeInsets.all(10.0),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: SizedBox(
//             width: 35,
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: AnimatedBuilder(
//                 animation: animation,
//                 builder: (context, child) => DotsIndicator(
//                   dotsCount: 3,
//                   position: animation.value,
//                   decorator: DotsDecorator(
//                     color: Colors.grey.withOpacity(0.5), // Inactive color
//                     activeColor: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// class BottomLoader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//       elevation: 1,
//       margin: EdgeInsets.all(10.0),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: SizedBox(
//             width: 20,
//             child: FittedBox(
//                 fit: BoxFit.scaleDown, child: CircularProgressIndicator()),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../repositories/index.dart';
import '../../ui/widgets/index.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) => ListViewPage<NewsRepository>(
        buildFunction: (BuildContext context, int index) {
          model.handleScrollWithIndex(index);
          return index >= model.itemCount
              ? BottomLoader<NewsRepository>()
              : _buildNewsCard(context, index);
        },
        itemCount:
            model.hasReachedMax() ? model.itemCount : model.itemCount + 1,
      ),
    );
  }

  Widget _buildNewsHeader(String date) {
    return SizedBox(
      height: 38,
      child: ListTile(
        leading: CircleAvatar(),
        title: const Text(
          'СКФ МТУСИ',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          date,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, int index) {
    return Consumer<NewsRepository>(
      builder: (ctx, model, _) {
        final News news = model.news[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: _buildNewsHeader(news.getDate),
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
