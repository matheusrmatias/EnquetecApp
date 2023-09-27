import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repositories/student_repository.dart';

class ScheduleTab extends StatefulWidget {
  final onPressed;
  const ScheduleTab({super.key, required this.onPressed});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late Student student;
  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return RefreshIndicator(
      onRefresh: ()async{await widget.onPressed(student);},
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: student.schedule.length,
          itemBuilder: (context, index)=>ScheduleCard(schedule: student.schedule[index])),
    );
  }
}

