import 'package:enquetec/src/admin/controllers/student_controller_admin.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/student_admin_repository.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../../themes/main.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  StudentCard({required this.student});
  late StudentAdminRepository studentAdminRep;
  late Coordinator coordinator;

  @override
  Widget build(BuildContext context) {
    studentAdminRep = Provider.of<StudentAdminRepository>(context);
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: MainColors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(10)),

          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(student.name, style: TextStyle(color: MainColors.orange, fontSize: 14,  fontWeight: FontWeight.bold)))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                  children: [
                    Expanded(child: Text(student.email, textAlign: TextAlign.justify,style: const TextStyle(fontSize: 12)))
                  ]
              ),
              const SizedBox(height: 8),
              Row(
                  children: [
                    Expanded(child: Text(student.ra, textAlign: TextAlign.justify,style: const TextStyle(fontSize: 12)))
                  ]
              ),

            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: MainColors.black2,
              borderRadius: const BorderRadius.all(Radius.circular(100))
          ),

          child: IconButton(onPressed: ()async{
            StudentControllerAdmin control = StudentControllerAdmin();
            try{
              await control.deleteStudent(student,coordinator);
              List<Student> students = studentAdminRep.allStudents;

              students.removeWhere((element) => element.email==student.email);

              studentAdminRep.allStudents = students;
              studentAdminRep.students = students;
            }catch (e){
              debugPrint(e.toString());
              Fluttertoast.showToast(msg: 'Não foi possível excluir o aluno');
            }

          }, icon: Icon(UniconsLine.trash, color: MainColors.red, size: 20)),
        )
      ],
    );
  }
}
