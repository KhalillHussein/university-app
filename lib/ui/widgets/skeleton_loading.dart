import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      color: Theme.of(context).appBarTheme.color,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTopBox(context),
                _buildAnimationContainer(
                  context,
                  height: 2.0,
                  width: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
                _buildMiddleBox(context, width),
                _buildBottomBox(context, width),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimationContainer(BuildContext context,
      {double height, double width, BorderRadiusGeometry borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).disabledColor,
      highlightColor: Colors.white10,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).disabledColor,
        ),
      ),
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
            Shimmer.fromColors(
              baseColor: Theme.of(context).disabledColor,
              highlightColor: Colors.white10,
              child: CircleAvatar(
                radius: 21.0,
                backgroundColor: Theme.of(context).disabledColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: _buildAnimationContainer(
                  context,
                  height: 13.0,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10.0),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: _buildAnimationContainer(
                    context,
                    height: 13.0,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: _buildAnimationContainer(
                    context,
                    height: 13.0,
                    width: width * 0.4,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: _buildAnimationContainer(
                    context,
                    height: 13.0,
                    width: width * 0.6,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildAnimationContainer(
              context,
              height: 24.0,
              width: width * 0.4,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          _buildAnimationContainer(
            context,
            height: 170.0,
            width: double.infinity,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildAnimationContainer(
                  context,
                  height: 30.0,
                  width: 55.0,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: _buildAnimationContainer(
                    context,
                    height: 30.0,
                    width: 55.0,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
