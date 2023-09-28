import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/widgets/discipline_note_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/main.dart';

class NotesTab extends StatefulWidget {
  final Function(Student) onPressed;
  const NotesTab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late Student student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return Container(
      color: MainColors.black2,
      child: RefreshIndicator(
        onRefresh: ()async{await widget.onPressed(student);},
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: student.assessment.length,
          itemBuilder: (context, index)=>DisciplineNoteCard(discipline: student.assessment[index]),
        ),
      ),
    );
  }
}
