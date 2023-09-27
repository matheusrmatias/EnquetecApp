import 'package:enquetec/src/controllers/notification_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/repositories/notification_student_repository.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/widgets/NotificationStudentCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../admin/models/notification_model.dart';
import '../../themes/main.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationStudentRepository notifications;
  late Student student;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifications = Provider.of<NotificationStudentRepository>(context);
    student = Provider.of<StudentRepository>(context).student;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('NOTIFICAÇÕES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          NotificationController control = NotificationController();
          try{
            List<NotificationModel> listNotify = await control.queryFirebase(student);
            await control.updateAllDatabase(listNotify);
            notifications.notifications = listNotify;
            Fluttertoast.showToast(msg: 'Notificações atualizadas');
          }catch (e){
            Fluttertoast.showToast(msg: 'Ocorreu um Erro');
          }
        },
        child: notifications.notifications.isEmpty?
          ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text('Sem notificações',style: TextStyle(color: MainColors.white)))
              ],
            )]
          ):
          ListView.builder(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: notifications.notifications.length,
              itemBuilder: (context, index){
                return NotificationStudentCard(notification: notifications.notifications[index]);
              }
          ),
      )
    );
  }
}
