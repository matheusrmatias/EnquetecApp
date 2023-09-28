import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:enquetec/src/app_widget.dart';
import 'package:enquetec/src/controllers/notification_controller.dart';
import 'package:enquetec/src/models/cousers.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/repositories/notification_student_repository.dart';
import 'package:enquetec/src/repositories/setting_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> onReceiveNotification(RemoteMessage message) async{
  SettingRepository setting = Provider.of<SettingRepository>(NavigationService.navigatorKey.currentContext!, listen: false);
  NotificationStudentRepository notification = Provider.of<NotificationStudentRepository>(NavigationService.navigatorKey.currentContext!, listen: false);
  NotificationController controller = NotificationController();

  await controller.insertDatabase(NotificationModel(
      link: message.data['link'],
      title: message.notification!.title!,
      body: message.notification!.body!,
      initialDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.data['initialDate'].toString())!)),
      finalDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(message.data['finalDate'].toString())!)),
      course: message.data['course'],
      coordinator: message.data['coordinator'],
      uid: message.data['uid'])
  );
  List<NotificationModel> notifs = await controller.queryAllDatabase();
  notifs.sort((a,b) => b.finalDate.compareTo(a.finalDate));
  notification.notifications = notifs;
  setting.newNotificaiton = true;
}

Future<void> onReceiveNotificationBackground(RemoteMessage message)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('newNotification', true);
  debugPrint('newNotification');

}

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
   await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(onReceiveNotification);
    FirebaseMessaging.onMessage.listen(onReceiveNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(onReceiveNotification);
  }

  Future<void> initTopics(Student student) async {
    // if(student.graduation=='Tecnologia em Análise e Desenvolvimento de Sistemas'){
    //   await _firebaseMessaging.subscribeToTopic('ads');
    // }else if(student.graduation=='Tecnologia em Gestão da Produção Indústrial'){
    //   await _firebaseMessaging.subscribeToTopic('gpi');
    // }else if(student.graduation == 'Tecnologia em Comércio Exterior'){
    //   await _firebaseMessaging.subscribeToTopic('comex');
    // }
    await _firebaseMessaging.subscribeToTopic(
        Courses.names[student.graduation.toUpperCase()]!);
    await _firebaseMessaging.subscribeToTopic('todos');
  }

  Future<void> endTopic(Student student) async {
    // await _firebaseMessaging.unsubscribeFromTopic(
    //     Courses.names[student.graduation.toUpperCase()]!);
    // await _firebaseMessaging.unsubscribeFromTopic('todos');
    FirebaseMessaging.onBackgroundMessage((e)async{});
    FirebaseMessaging.onMessage.listen((e)async{});
    FirebaseMessaging.onMessageOpenedApp.listen((e)async{});
  }


}