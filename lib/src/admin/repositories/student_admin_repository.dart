import 'package:enquetec/src/models/student.dart';
import 'package:flutter/cupertino.dart';

class StudentAdminRepository extends ChangeNotifier{
  late List<Student> _students;
  List<Student> allStudents;

  StudentAdminRepository({required this.allStudents}){
    _students = allStudents;
  }

  List<Student> get students => _students;

  set students(List<Student> value) {
    _students = value;
    notifyListeners();
  }
}