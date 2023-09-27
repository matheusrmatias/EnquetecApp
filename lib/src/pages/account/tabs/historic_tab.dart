import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/main.dart';
import '../../../widgets/discipline_historic_card.dart';

class HistoricTab extends StatefulWidget {
  final onPressed;
  const HistoricTab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<HistoricTab> createState() => _HistoricTabState();
}

class _HistoricTabState extends State<HistoricTab> {
  late Student student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return RefreshIndicator(
      onRefresh: ()async{await widget.onPressed(student);},
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: student.historic.length,
        itemBuilder: (context, index) => DisciplineHistoricCard(discipline: student.historic[index]),
      ),
    );
  }
}
