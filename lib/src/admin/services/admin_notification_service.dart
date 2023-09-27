import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/messages_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/models/message_model.dart';
import 'package:enquetec/src/admin/repositories/message_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import '../../app_widget.dart';
import '../../models/cousers.dart';

Future<void> onReceiveNotification(RemoteMessage message) async{
  MessageRepository messageRepository = Provider.of<MessageRepository>(NavigationService.navigatorKey.currentContext!, listen: false);
  MessageControl controller = MessageControl();
  Message mess =
  Message(
      uid: message.data['uid'],
      text: message.notification!.body.toString(),
      type: message.notification!.title.toString(),
      name: message.data['name'],
      date: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(message.data['date'].toString())))
  );

  List<Message> messages = messageRepository.messages;
  messages.insert(0, mess);

  messageRepository.allMessages = messages;
  messageRepository.messages = messages;
  await controller.insertDatabase(mess);
}


class AdminNotificationService{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
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

  Future<void> initTopics(Coordinator coordinator) async {
    // if(student.graduation=='Tecnologia em Análise e Desenvolvimento de Sistemas'){
    //   await _firebaseMessaging.subscribeToTopic('ads');
    // }else if(student.graduation=='Tecnologia em Gestão da Produção Indústrial'){
    //   await _firebaseMessaging.subscribeToTopic('gpi');
    // }else if(student.graduation == 'Tecnologia em Comércio Exterior'){
    //   await _firebaseMessaging.subscribeToTopic('comex');
    // }
    await _firebaseMessaging.subscribeToTopic(
        AdminCourses.names[coordinator.course.toUpperCase()]!);
  }

  Future<void> endTopic(Coordinator coordinator) async {
    String topic = AdminCourses.names[coordinator.course.toUpperCase()]!;
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    FirebaseMessaging.onBackgroundMessage((e)async{});
    FirebaseMessaging.onMessage.listen((e)async{});
    FirebaseMessaging.onMessageOpenedApp.listen((e)async{});
  }
}