import 'package:flutter/cupertino.dart';

import '../models/student.dart';

class StudentRepository extends ChangeNotifier{
  Student _student;

  StudentRepository(this._student);

  Student get student => _student;

  set student(Student value) {
    _student = value;
    notifyListeners();
  }
}