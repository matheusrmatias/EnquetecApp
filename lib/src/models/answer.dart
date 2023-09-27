import 'package:cloud_firestore/cloud_firestore.dart';

class Answer{
  final String uid;
  final String studentRA;
  final Timestamp dateAnswer;
  final String enqueteUid;
  final Map<String,String> questions;
  final String course;
  final String discipline;
  final String coordinator;
  final Timestamp initialDate;
  final Timestamp finalDate;

  Answer({required this.uid, required this.enqueteUid, required this.studentRA,required this.dateAnswer, required this.questions, required this.course, required this.coordinator, required this.discipline, required this.initialDate, required this.finalDate});

}