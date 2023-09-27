class DisciplineAssessment{
  DisciplineAssessment();

  String _name = '';
  String _teacher = '';
  String _acronym = '';
  String _average = '';
  String _absence = '';
  String _frequency = '';
  String _maxAbsences = '';
  String _syllabus = '';
  String _totalClasses = '';
  String _objective = '';

  Map<String, String> _assessment = {};

  String get totalClasses => _totalClasses;

  set totalClasses(String value) {
    _totalClasses = value;
  }

  String get syllabus => _syllabus;

  set syllabus(String value) {
    _syllabus = value;
  }

  String get maxAbsences => _maxAbsences;

  set maxAbsences(String value) {
    _maxAbsences = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get acronym => _acronym;

  Map<String, String> get assessment => _assessment;

  set assessment(Map<String, String> value) {
    _assessment = value;
  }

  String get frequency => _frequency;

  set frequency(String value) {
    _frequency = value;
  }

  String get absence => _absence;

  set absence(String value) {
    _absence = value;
  }

  String get average => _average;

  set average(String value) {
    _average = value;
  }

  set acronym(String value) {
    _acronym = value;
  }

  String get teacher => _teacher;

  set teacher(String value) {
    _teacher = value;
  }

  String get objective => _objective;

  set objective(String value) {
    _objective = value;
  }

}