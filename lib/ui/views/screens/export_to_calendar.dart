// import 'package:device_calendar/device_calendar.dart';
// import 'package:flutter/material.dart';
// import 'package:mtusiapp/providers/index.dart';
// import 'package:provider/provider.dart';
//
// class ExportToCalendarScreen extends StatefulWidget {
//   @override
//   _ExportToCalendarScreenState createState() => _ExportToCalendarScreenState();
// }
//
// class _ExportToCalendarScreenState extends State<ExportToCalendarScreen> {
//   //
//   DeviceCalendarPlugin _deviceCalendarPlugin;
//   List<Calendar> _calendars;
//   Calendar _selectedCalendar;
//
//   //
//   Future<void> _retrieveCalendars() async {
//     //Retrieve user's calendars from mobile device
//     //Request permissions first if they haven't been granted
//     try {
//       var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
//       if (permissionsGranted.isSuccess && !permissionsGranted.data) {
//         permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
//         if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
//           return;
//         }
//       }
//       final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
//       setState(() {
//         _calendars = calendarsResult?.data;
//       });
//       _calendars = calendarsResult?.data;
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   void initState() {
//     //
//     _deviceCalendarPlugin = DeviceCalendarPlugin();
//     _retrieveCalendars();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Экспорт в календарь')),
//       body: ListView.builder(
//         itemCount: _calendars?.length ?? 0,
//         itemBuilder: (BuildContext context, int index) {
//           return Consumer<TableCalendarProvider>(
//             builder: (ctx, model, _) => InkWell(
//               onTap: () async {
//                 setState(() {
//                   _selectedCalendar = _calendars[index];
//                 });
//                 for (final item in model.timetableList) {
//                   final eventToCreate = Event(_calendars[index].id);
//                   eventToCreate.title = item.subject;
//                   eventToCreate.start = item.date;
//                   eventToCreate.description = item.subjectType;
//                   eventToCreate.end =
//                       item.date.add(const Duration(minutes: 45));
//                   final createEventResult = await _deviceCalendarPlugin
//                       .createOrUpdateEvent(eventToCreate);
//                   if (createEventResult.isSuccess &&
//                       (createEventResult.data?.isNotEmpty ?? false)) {
//                     print('added');
//                   }
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Text(
//                         _calendars[index].name,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         _calendars[index].accountType,
//                       ),
//                     ),
//                     Icon(
//                       _calendars[index].isReadOnly
//                           ? Icons.lock
//                           : Icons.lock_open,
//                       color: Colors.white,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
