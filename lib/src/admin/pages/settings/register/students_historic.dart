import 'package:enquetec/src/admin/controllers/student_controller_admin.dart';
import 'package:enquetec/src/admin/repositories/student_admin_repository.dart';
import 'package:enquetec/src/admin/widgets/student_card.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHistoric extends StatefulWidget {
  const StudentHistoric({super.key});

  @override
  State<StudentHistoric> createState() => _StudentHistoricState();
}

class _StudentHistoricState extends State<StudentHistoric> {
  late StudentAdminRepository studentAdminRep;

  @override
  Widget build(BuildContext context) {
    studentAdminRep = Provider.of<StudentAdminRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALUNOS CADASTRADOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      backgroundColor: MainColors.black2,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: RefreshIndicator(
          onRefresh: ()async{
            StudentControllerAdmin control = StudentControllerAdmin();
            studentAdminRep.allStudents = await control.queryAllStudent();
            studentAdminRep.students = studentAdminRep.allStudents;
          },
          child: ListView.builder(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: studentAdminRep.students.length,
              itemBuilder: (ctx,index){
                return StudentCard(student: studentAdminRep.students[index]);
              }
          ),
        ),
      )
    );
  }
}
