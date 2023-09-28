import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:enquetec/src/controllers/student_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/pages/account/tabs/historic_tab.dart';
import 'package:enquetec/src/pages/account/tabs/notes_tab.dart';
import 'package:enquetec/src/pages/account/tabs/schedule_tab.dart';
import 'package:enquetec/src/login_page.dart';
import 'package:enquetec/src/repositories/setting_repository.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../services/student_account.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>{
  late SettingRepository prefs;
  late Student student;
  List<Widget> historic = [];
  StudentController control = StudentController();
  late StudentRepository studentRep;
  @override
  initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    studentRep = Provider.of<StudentRepository>(context);
    prefs = Provider.of<SettingRepository>(context);

    return Scaffold(
      backgroundColor: MainColors.black2,
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          padding: const EdgeInsets.only(bottom: 4),
          indicatorColor: MainColors.orange,
          labelColor: MainColors.orange,
          unselectedLabelColor: MainColors.white2
        ),
          tabBarViewProperties: const TabBarViewProperties(
            physics: BouncingScrollPhysics()
          ),
          tabs: const [
            Tab(child: Text('Notas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Tab(child: Text('Histórico', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Tab(child: Text('Horários', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))
          ],
          views: [
            NotesTab(onPressed: _updateStudentDate),
            HistoricTab(onPressed: _updateStudentDate),
            ScheduleTab(onPressed: _updateStudentDate)
          ]),
    );
    //
    // return DefaultTabController(
    //   length: 3,
    //   initialIndex: 0,
    //   child: Scaffold(
    //   appBar: AppBar(
    //     title: TabBar(
    //       physics: const BouncingScrollPhysics(),
    //       tabs: const [
    //         Tab(child: Text('Notas', style: TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis,)),
    //         Tab(child: Text('Histórico', style: TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis,)),
    //         Tab(child: Text('Horários', style: TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis,))
    //       ],
    //       labelColor: MainColors.orange,
    //       unselectedLabelColor: MainColors.black,
    //       labelStyle: const TextStyle(fontSize: 16),
    //       indicatorColor: Colors.transparent,
    //       dividerColor: Colors.transparent,
    //     ),
    //     backgroundColor: MainColors.white,
    //     shadowColor: Colors.transparent,
    //   ),
    //   body: TabBarView(
    //     physics: const BouncingScrollPhysics(),
    //     children:  [
    //       NotesTab(onPressed: _updateStudentDate),
    //       HistoricTab(onPressed: _updateStudentDate),
    //       ScheduleTab(onPressed: _updateStudentDate)
    //     ],
    //   ),
    // ),
    // );
  }

  Future<void> _updateStudentDate(Student student)async{
    StudentAccount account = StudentAccount();
    try{
      await account.userLogin(student);
      await account.userHistoric(student);
      await account.userAssessment(student);
      await account.userSchedule(student);
      await account.userAbsences(student);
      await account.userAssessmentDetails(student);
      await control.updateDatabase(student);
      studentRep.student = student;
      setState(() {
        student = student;
      });
      Fluttertoast.showToast(msg: 'Dados atualizados com sucesso!');
    }catch(e){
      debugPrint('Error $e');
      if(e.toString() == 'Exception: User or Password Incorrect'){
        Fluttertoast.showToast(msg: 'Faça o Login Novamente');
        control.deleteDatabase();
        Navigator.pushReplacement(context, PageTransition(child:const LoginPage(), type: PageTransitionType.fade));
      }else{
        Fluttertoast.showToast(msg: 'Ocorreu um erro, tente novamente!');
      }
    }
  }

}
