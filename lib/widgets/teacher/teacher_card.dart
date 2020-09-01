import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

import '../cache_image.dart';

class TeacherCard extends StatelessWidget {
  final int id;
  final String name;
  final String power;
  final String specification;
  final String photo;

  TeacherCard({
    this.id,
    @required this.name,
    @required this.power,
    @required this.specification,
    @required this.photo,
  });

//  Widget _buildTeacherAvatar(BuildContext context) {
//    return GestureDetector(
//      onTap: () {
//        Navigator.pushNamed(context, PhotoViewScreen.routeName,
//            arguments: {'imageUrl': photo});
//      },
//      child: Hero(
//        tag: photo,
//        child: CacheImage.teacher(url: photo),
//      ),
//    );
//  }

  Widget _buildTeacherInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'СКФ МТУСИ',
            style: TextStyle(fontSize: 11, letterSpacing: 1),
          ),
          Text(
            name,
            style: TextStyle(fontSize: 21),
          ),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: const Icon(
                    CommunityMaterialIcons.account_tie,
                    size: 23,
                  ),
                ),
                TextSpan(
                  text: ' $power',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: const Icon(
                    CommunityMaterialIcons.book_open,
                    size: 23,
                  ),
                ),
                TextSpan(
                  text: ' $specification',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.1),
        color: Theme.of(context).cardTheme.color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeacherInfo(context),
                  CacheImage.teacher(url: photo),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: FlatButton(
              padding: const EdgeInsets.all(10),
              onPressed: () {},
              child: const Text(
                'ПОДРОБНЕЕ',
                style: TextStyle(letterSpacing: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
