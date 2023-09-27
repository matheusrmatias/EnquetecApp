import 'package:flutter/material.dart';

import '../models/answer.dart';

class AnswerRepository extends ChangeNotifier{
  late List<Answer> _answers;
  List<Answer> allAnswers;

  AnswerRepository({required this.allAnswers}){
    _answers = allAnswers;
  }

  List<Answer> get answers => _answers;

  set answers(List<Answer> value) {
    _answers = value;
    notifyListeners();
  }
}