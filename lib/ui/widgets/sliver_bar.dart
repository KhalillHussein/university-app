import 'package:flutter/material.dart';

/// Custom sliver app bar used in Sliver views.
/// It collapses when user scrolls down.
class SliverBar extends StatelessWidget {
  static const double heightRatio = 0.31;

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

      // pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: header,
      ),
    );
  }
}
