import 'package:flutter/cupertino.dart';

import '../models/enquete_model.dart';

class EnqueteAdminRepository extends ChangeNotifier{
  List<EnqueteModel> allEnquetes;
  late List<EnqueteModel> _enquetes;

  EnqueteAdminRepository({required this.allEnquetes}){
    _enquetes = allEnquetes;
  }

  List<EnqueteModel> get enquetes => _enquetes;

  set enquetes(List<EnqueteModel> value) {
    _enquetes = value;
    notifyListeners();
  }

  void cleanEnquete({bool listen = true}){
    _enquetes = allEnquetes;
    if(listen)notifyListeners();
  }
}