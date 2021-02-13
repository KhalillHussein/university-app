// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../util/sections.dart';
// import 'dynamic_treeview.dart';
//
// class AppDrawer extends StatefulWidget {
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: CupertinoScrollbar(
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               _buildDrawerHeader(context),
//               const Divider(),
//               DynamicTreeView(
//                 data: getData(),
//                 config: Config(
//                   parentTextStyle: Theme.of(context).textTheme.bodyText2,
//                   parentPaddingEdgeInsets:
//                       EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
//                   childrenPaddingEdgeInsets:
//                       EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
//                   childrenTextStyle: Theme.of(context).textTheme.bodyText2,
//                 ),
//                 onTap: (m) {
//                   debugPrint("onChildTap -> $m");
//                   if (m['extra']['routeName'] != null) {
//                     Navigator.pushNamed(context, m['extra']['routeName']);
//                   }
//                 },
//                 width: double.infinity,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDrawerHeader(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 40.0, left: 15.0, bottom: 10.0),
//       child: Text(
//         'Сведения об образовательной организации',
//         style: TextStyle(
//           fontSize: 18,
//           color: Theme.of(context).textTheme.headline6.color,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   List<BaseData> getData() {
//     return Sections.drawerSections.map((item) {
//       return DataModel(
//           id: item['id'],
//           parentId: item['parentId'],
//           name: item['title'],
//           icon: item['icon'],
//           extras: {'routeName': item['routeName']});
//     }).toList();
//   }
// }
//
// class DataModel implements BaseData {
//   final int id;
//   final int parentId;
//   String name;
//   IconData icon;
//
//   ///Any extra data you want to get when tapped on children
//   Map<String, dynamic> extras;
//   DataModel({this.id, this.parentId, this.name, this.extras, this.icon});
//   @override
//   String getId() {
//     return id.toString();
//   }
//
//   @override
//   Map<String, dynamic> getExtraData() {
//     return extras;
//   }
//
//   @override
//   String getParentId() {
//     return parentId.toString();
//   }
//
//   @override
//   String getTitle() {
//     return name;
//   }
//
//   @override
//   IconData getIcon() {
//     return icon;
//   }
// }

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(context),
          // const Divider(),
          ListTile(
            leading: Icon(
              MdiIcons.formatListBulleted,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Transform.translate(
              offset: Offset(-18, 2),
              child: Text(
                'Разделы',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              MdiIcons.fileDocumentEditOutline,
              size: 28,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Transform.translate(
              offset: Offset(-18, 2),
              child: Text(
                'Заказ справок и документов',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
        ),
        title: Text(
          'Иван Иванов',
          style: Theme.of(context).textTheme.headline5,
        ),
        subtitle: Text(
          'ДИ-11',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ),
    );

    //   Padding(
    //   padding: const EdgeInsets.only(top: 40.0, left: 15.0, bottom: 10.0),
    //   child: Text(
    //     'Сведения об образовательной организации',
    //     style: TextStyle(
    //       fontSize: 20,
    //       color: Theme.of(context).textTheme.headline6.color,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );
  }
}
