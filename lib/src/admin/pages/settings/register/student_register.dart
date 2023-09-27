import 'package:enquetec/src/admin/controllers/student_controller_admin.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/pages/settings/register/students_historic.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/student_admin_repository.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/widgets/login_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../../../../themes/main.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({super.key});

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  TextEditingController studentName = TextEditingController();
  TextEditingController studentEmail = TextEditingController();
  TextEditingController studentRA = TextEditingController();
  bool inRegister = false;
  late Coordinator coordinator;
  late StudentAdminRepository studentAdminRep;

  @override
  Widget build(BuildContext context) {
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    studentAdminRep = Provider.of<StudentAdminRepository>(context);
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('CADASTRAR ALUNO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 4,),
              GestureDetector(
                onTap: ()=>Navigator.push(context, PageTransition(child: const StudentHistoric(), type: PageTransitionType.rightToLeft)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Text('Ver alunos cadastrados', style: TextStyle(color: MainColors.orange, fontSize: 14))),
                    Icon(Icons.access_time_outlined, color: MainColors.orange, size: 12)
                  ],
                ),
              ),
              LoginInput(text: 'Nome', hidden: false, icon: const Icon(Icons.person), controller: studentName, hint: 'Nome', backgroundColor: MainColors.grey, textColor: MainColors.orange),
              LoginInput(text: 'Email', hidden: false, icon: const Icon(Icons.email), controller: studentEmail, hint: 'nome@mail.com', backgroundColor: MainColors.grey, textColor: MainColors.orange),
              LoginInput(text: 'RA', hidden: false, lenght: 13,type: TextInputType.number,icon: const Icon(UniconsLine.graduation_cap), controller: studentRA, hint: '1310482000001', backgroundColor: MainColors.grey, textColor: MainColors.orange),
              ElevatedButton(
                onPressed: (){
                  if(studentName.text.isEmpty || studentEmail.text.isEmpty || studentRA.text.isEmpty){
                    Fluttertoast.showToast(msg: 'O Nome, E-mail e RA não podem ser vazios.');
                    return;
                  }
                  if(!studentEmail.text.contains('@fatec.sp.gov.br')){
                    Fluttertoast.showToast(msg: 'O email tem que ser de dominio "@fatec.sp.gov.br"');
                    return;
                  }
                  if(studentRA.text.length!=13){
                    Fluttertoast.showToast(msg: 'O RA tem que ter 13 caracteres numéricos');
                    return;
                  }

                  showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: MainColors.black2,
                              borderRadius: const BorderRadius.all(Radius.circular(16))
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Row(
                                  children: [Flexible(child: Text('Confirmar dados:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MainColors.white2)))],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('Nome: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: MainColors.white2)),Expanded(child: Text(studentName.text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: MainColors.orange)))],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('E-mail: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: MainColors.white2)),Expanded(child: Text(studentEmail.text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: MainColors.orange)))],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('RA: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: MainColors.white2)),Expanded(child: Text(studentRA.text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: MainColors.orange)))],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(child: TextButton(onPressed: (){_registerStudent();Navigator.pop(context);}, child: const Text('Confirmar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 40)
                ),
                child: inRegister? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24):Text('Cadastrar', style: TextStyle(color: MainColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  _registerStudent()async{
    setState(()=>inRegister = !inRegister);
    FirebaseAuth auth = FirebaseAuth.instance;
    StudentControllerAdmin studentControl = StudentControllerAdmin();
    try{
      await auth.signOut();
      UserCredential user = await auth.createUserWithEmailAndPassword(email: studentEmail.text, password: studentRA.text).whenComplete(()async{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: coordinator.email, password: coordinator.password);
      });
      Student student = Student(cpf: '', password: '');
      student.email = studentEmail.text;
      student.name = studentName.text;
      student.ra = studentRA.text;
      await studentControl.insertStudent(student,user.user!.uid);
      List<Student> students = studentAdminRep.allStudents;
      students.add(student);
      studentAdminRep.allStudents = students;
      studentAdminRep.students = students;
      Fluttertoast.showToast(msg: 'Aluno cadastrado com sucesso');
      debugPrint(auth.currentUser!.uid);
      studentName.clear();
      studentEmail.clear();
      studentRA.clear();
    }catch (e){
      debugPrint('Error: $e');
      if(auth.currentUser!.uid != coordinator.uid){
        await auth.currentUser!.delete();
      }
      Fluttertoast.showToast(msg: 'Erro ao cadastrar o aluno');
    }finally{
      setState(()=>inRegister = !inRegister);
    }
  }
}
