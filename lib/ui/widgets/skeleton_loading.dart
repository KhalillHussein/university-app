import 'package:flutter/material.dart';

import 'package:row_collection/row_collection.dart';
import 'package:shimmer/shimmer.dart';

class NewsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          color: Theme.of(context).cardColor,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopBox(context),
              Separator.spacer(space: 6),
              _AnimationContainer(
                size: Size(double.infinity, 1),
              ),
              _buildMiddleBox(context, width),
              _buildBottomBox(context, width),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        color: Theme.of(context).cardTheme.color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _AnimationContainer(
              size: Size(45, 45),
              borderRadius: BorderRadius.circular(100.0),
            ),
            Expanded(
              child: _AnimationContainer(
                margin: const EdgeInsets.only(left: 15.0),
                size: Size(double.infinity, 13.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleBox(BuildContext context, double width) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        color: Theme.of(context).cardTheme.color,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AnimationContainer(
                  margin: const EdgeInsets.symmetric(vertical: 3.0),
                  size: Size(double.infinity, 13.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                _AnimationContainer(
                  margin: const EdgeInsets.symmetric(vertical: 3.0),
                  size: Size(width * 0.4, 13.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                _AnimationContainer(
                  margin: const EdgeInsets.symmetric(vertical: 3.0),
                  size: Size(width * 0.6, 13.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBox(BuildContext context, double width) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        color: Theme.of(context).cardTheme.color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AnimationContainer(
            size: Size(width * 0.4, 24),
            margin: const EdgeInsets.all(15.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          _AnimationContainer(
            size: Size(double.infinity, 170.0),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _AnimationContainer(
                  size: Size(55, 30.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                _AnimationContainer(
                  size: Size(55, 30.0),
                  margin: const EdgeInsets.only(left: 10.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LecturersPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (ctx, index) => _AnimationContainer(
        size: Size(width, 1),
        margin: const EdgeInsets.only(left: 78),
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Row(
            children: [
              _AnimationContainer(
                size: Size(48, 48),
                borderRadius: const BorderRadius.all(
                  Radius.circular(2.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnimationContainer(
                      size: Size(width * 0.7, 18),
                    ),
                    Separator.spacer(),
                    _AnimationContainer(
                      size: Size(width * 0.5, 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimationContainer extends StatelessWidget {
  final Size size;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const _AnimationContainer({
    @required this.size,
    this.borderRadius,
    this.padding,
    this.margin,
  }) : assert(size != null);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[400]
          : Colors.white24,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]
          : Colors.white70,
      period: const Duration(milliseconds: 1000),
      child: Container(
        height: size.height,
        width: size.width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
