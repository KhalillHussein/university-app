import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/teacher_provider.dart';
import 'teacher_card.dart';

class TeachersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(
      builder: (ctx, teacherData, _) => ListView.builder(
        itemCount: teacherData.itemCount,
        itemBuilder: (ctx, index) {
          final teacher = teacherData.items[index];
          return TeacherCard(
            id: teacher.id,
            name: teacher.name,
            power: teacher.power,
            specification: teacher.specification,
            photo: teacher.photo,
          );
        },
      ),
    );
  }
}
