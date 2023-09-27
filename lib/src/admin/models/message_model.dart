import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String text;
  final String type;
  final String name;
  final String uid;
  final Timestamp date;
  Message({required this.uid, required this.text, required this.type, required this.name, required this.date});
}