import 'package:cloud_firestore/cloud_firestore.dart';

class EnqueteModel{
  final String uid;
  final String course;
  final String discipline;
  final List<String> questions;
  final String coordinator;
  final Timestamp initialDate;
  final Timestamp finalDate;

  const EnqueteModel({required this.uid, required this.course, required this.discipline, required this.coordinator, required this.initialDate, required this.finalDate, required this.questions});
}