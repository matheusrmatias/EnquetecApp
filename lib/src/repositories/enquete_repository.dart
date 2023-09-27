import 'package:flutter/cupertino.dart';

import '../models/enquete.dart';

class EnqueteRepository extends ChangeNotifier{
  late List<Enquete> _enquetes;
  List<Enquete> allEnquetes;

  EnqueteRepository({required this.allEnquetes}){
    _enquetes = allEnquetes;
  }

  List<Enquete> get enquetes => _enquetes;

  set enquetes(List<Enquete> value) {
    _enquetes = value;
    notifyListeners();
  }
}