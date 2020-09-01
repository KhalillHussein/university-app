import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule_provider.dart';
import '../widgets/schedule/schedule_list.dart';
import '../screens/error_screen.dart';

class ScheduleScreen extends StatelessWidget {
  Widget _buildFuture(BuildContext context, provider) {
    return FutureBuilder(
      future: provider.fetchAndSetResult(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataSnapshot.error != null) {
            print(dataSnapshot.error);
            return ErrorScreen.schedule(context);
          } else {
            return ScheduleList();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild_schedule');
    return Consumer<ScheduleProvider>(
      builder: (ctx, dataSchedule, _) => dataSchedule.items.isEmpty
          ? _buildFuture(context, dataSchedule)
          : ScheduleList(),
    );
  }
}
