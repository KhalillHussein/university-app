import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/schedule_provider.dart';
import '../widgets/schedule_list.dart';
import 'error.dart';

class SchedulePage extends StatelessWidget {
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
            return ErrorPage.schedule(context);
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
