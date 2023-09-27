import 'package:enquetec/src/models/assessment.dart';

import 'schedule.dart';

class Student{
  String cpf;
  String password;
  Student({required this.cpf,required this.password});

  String _name = '';
  String _email = '';
  String _ra = '';
  String _pp = '';
  String _pr = '';
  String _cycle = '';
  String _imageUrl = '';
  String _fatec = '';
  String _progress = '';
  String _graduation = '';
  String _period = '';
  List<Map<String,String>> _historic = [];
  List<DisciplineAssessment> _assessment = [];
  List<Schedule> _schedule = [];

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  List<Map<String, String>> get historic => _historic;

  set historic(List<Map<String, String>> value) {
    _historic = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get cycle => _cycle;

  set cycle(String value) {
    _cycle = value;
  }

  String get pr => _pr;

  set pr(String value) {
    _pr = value;
  }

  String get pp => _pp;

  set pp(String value) {
    _pp = value;
  }

  String get ra => _ra;

  set ra(String value) {
    _ra = value;
  }

  set email(String value) {
    _email = value;
  }

  String get period => _period;

  set period(String value) {
    _period = value;
  }

  String get graduation => _graduation;

  set graduation(String value) {
    _graduation = value;
  }

  String get progress => _progress;

  set progress(String value) {
    _progress = value;
  }

  String get fatec => _fatec;

  set fatec(String value) {
    _fatec = value;
  }

  List<DisciplineAssessment> get assessment => _assessment;

  set assessment(List<DisciplineAssessment> value) {
    _assessment = value;
  }

  List<Schedule> get schedule => _schedule;

  set schedule(List<Schedule> value) {
    _schedule = value;
  }
}