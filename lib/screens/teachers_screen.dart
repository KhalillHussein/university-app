import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/teacher/teachers_list.dart';
import '../providers/teacher_provider.dart';
import '../screens/error_screen.dart';

class TeachersScreen extends StatelessWidget {
  static const routeName = '/teachers';

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
            return ErrorScreen.teacher(context);
          } else {
            return TeachersList();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Преподаватели')),
      body: Consumer<TeacherProvider>(
        builder: (ctx, teacherData, _) => teacherData.items.isEmpty
            ? _buildFuture(context, teacherData)
            : TeachersList(),
      ),
    );
  }
}
