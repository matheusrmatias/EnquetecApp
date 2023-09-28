import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/sqflite_coordinator_controller.dart';
import 'package:enquetec/src/admin/models/enquete_model.dart';
import 'package:enquetec/src/admin/models/result_enquete.dart';

class ResultAdminController extends SqfliteCoordinatorControler{
  Future<void> insertAllLocalDatabase(ResultEnquete result)async{

  }
  Future<void> insertCloudDatabase()async{

  }

  Future<ResultEnquete> queryCloudDatabase(EnqueteModel enquete)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    ResultEnquete result = ResultEnquete(questionsResult: {}, enquete: enquete);
    await db.collection('answers').where('enqueteUid', isEqualTo:  enquete.uid).get().then((value){
      int i = 0;
      for (var answer in value.docs) {
        if(i == 0){
            answer.data()['questions'].forEach((key, value) {
                result.questionsResult[key] = {
                  'Péssimo' : 0,
                  'Ruim' : 0,
                  'Regular' : 0,
                  'Bom' : 0,
                  'Excelente' : 0
                };
                int? val = result.questionsResult[key]![value.toString()];
                val==null? '': val+=1;
                result.questionsResult[key]![value.toString()] =  val ?? 0;
                i++;
            });
        }else{
          answer.data()['questions'].forEach((key, value) {
            int? val = result.questionsResult[key]?[value.toString()];
            val==null? val = 0: val+=1;
            result.questionsResult[key]?[value.toString()] = val;
            i++;
          });

        }

      }
    });


    return result;
  }
}