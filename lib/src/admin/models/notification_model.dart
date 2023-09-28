import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  final String title;
  final String body;
  final Timestamp initialDate;
  final Timestamp finalDate;
  final String course;
  final String coordinator;
  final String link;
  final String uid;
  NotificationModel({required this.link,required this.title, required this.body, required this.initialDate, required this.finalDate, required this.course, required this.coordinator, required this.uid});

}