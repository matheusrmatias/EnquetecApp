import 'package:flutter/cupertino.dart';

class AnswerUidRepository extends ChangeNotifier{
  late List<String> _uidList;
  List<String> allUidList;

  AnswerUidRepository({required this.allUidList}){
    _uidList = allUidList;
  }

  List<String> get uidList => _uidList;

  set uidList(List<String> value) {
    _uidList = value;
    notifyListeners();
  }
}