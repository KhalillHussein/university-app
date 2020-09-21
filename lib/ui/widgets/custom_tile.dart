import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final Widget trailing;
  final Color color;
  final EdgeInsets contentPadding;
  final Function onTap;

  CustomTile({
    this.icon,
    this.color,
    @required this.title,
    @required this.onTap,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 7.0),
    this.trailing,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: contentPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Icon(
                    icon,
                    color: Theme.of(context).iconTheme.color,
                    size: 28,
                  ),
                ),
              Expanded(child: title),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: trailing,
                ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
//
// class ParentWidget extends StatefulWidget {
//   final String title;
//   final List<String> items;
//   final IconData icon;
//
//   ParentWidget({
//     @required this.title,
//     this.items,
//     @required this.icon,
//     Key key,
//   }) : super(key: key);
//
//   @override
//   _ParentWidgetState createState() => _ParentWidgetState();
// }
//
// class _ParentWidgetState extends State<ParentWidget>
//     with SingleTickerProviderStateMixin {
//   bool shouldExpand = false;
//   Animation<double> sizeAnimation;
//   AnimationController expandController;
//
//   @override
//   void dispose() {
//     super.dispose();
//     expandController.dispose();
//   }
//
//   @override
//   void initState() {
//     prepareAnimation();
//     super.initState();
//   }
//
//   void prepareAnimation() {
//     expandController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     Animation curve =
//         CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
//     sizeAnimation = Tween(begin: 0.0, end: -0.5).animate(curve)
//       ..addListener(() {
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomTile(
//           icon: widget.icon,
//           title: widget.title,
//           trailing: widget.items != null
//               ? RotationTransition(
//                   turns: sizeAnimation,
//                   child: Icon(Icons.keyboard_arrow_down),
//                 )
//               : Container(),
//           onTap: () {
//             setState(() {
//               shouldExpand = !shouldExpand;
//             });
//             if (shouldExpand) {
//               expandController.forward();
//             } else {
//               expandController.reverse();
//             }
//           },
//         ),
//         widget.items != null
//             ? ChildWidget(
//                 items: widget.items,
//                 shouldExpand: shouldExpand,
//               )
//             : Container(),
//       ],
//     );
//   }
// }
//
// class ChildWidget extends StatefulWidget {
//   final List<String> items;
//   final bool shouldExpand;
//
//   ChildWidget({this.items, this.shouldExpand = false});
//
//   @override
//   _ChildWidgetState createState() => _ChildWidgetState();
// }
//
// class _ChildWidgetState extends State<ChildWidget>
//     with SingleTickerProviderStateMixin {
//   Animation<double> sizeAnimation;
//   AnimationController expandController;
//
//   @override
//   void didUpdateWidget(ChildWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.shouldExpand) {
//       expandController.forward();
//     } else {
//       expandController.reverse();
//     }
//   }
//
//   @override
//   void initState() {
//     prepareAnimation();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     expandController.dispose();
//   }
//
//   void prepareAnimation() {
//     expandController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     Animation curve =
//         CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
//     sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
//       ..addListener(() {
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizeTransition(
//       sizeFactor: sizeAnimation,
//       axisAlignment: -1.0,
//       child: Column(
//         children: _buildChildren(),
//       ),
//     );
//   }
//
//   _buildChildren() {
//     return widget.items.map((item) {
//       return CustomTile(
//         title: item,
//         onTap: () {},
//       );
//     }).toList();
//   }
// }
