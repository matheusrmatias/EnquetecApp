class Schedule{
  Schedule();

  String _weekDay = '';
  List<List<String>> _schedule = [];

  String get weekDay => _weekDay;

  set weekDay(String value) {
    _weekDay = value;
  }

  List<List<String>> get schedule => _schedule;

  set schedule(List<List<String>> value) {
    _schedule = value;
  }
}