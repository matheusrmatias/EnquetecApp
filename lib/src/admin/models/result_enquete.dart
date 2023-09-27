import 'package:enquetec/src/admin/models/enquete_model.dart';

class ResultEnquete{
  final EnqueteModel enquete;
  final Map<String, Map<String,int>> questionsResult;

 ResultEnquete({required this.questionsResult, required this.enquete});
}