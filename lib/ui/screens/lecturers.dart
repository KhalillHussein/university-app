import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/lecturers_list.dart';
import '../../providers/lecturer_provider.dart';
import '../pages/error.dart';

class LecturersScreen extends StatelessWidget {
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
            return ErrorPage.teacher(context);
          } else {
            return LecturerList();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Преподаватели')),
      body: Consumer<LecturerProvider>(
        builder: (ctx, lecturerData, _) => lecturerData.lecturers.isEmpty
            ? _buildFuture(context, lecturerData)
            : LecturerList(),
      ),
    );
  }
}
