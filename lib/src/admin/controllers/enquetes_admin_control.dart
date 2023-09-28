import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/sqflite_coordinator_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../models/enquete_model.dart';

class EnquetesAdminControl extends SqfliteCoordinatorControler{

  Future<void> insertCloudDatabase(EnqueteModel enquete)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('enquetes').doc(enquete.uid).set(
      {
        'course' : enquete.course,
        'coordinator' : enquete.coordinator,
        'discipline' : enquete.discipline,
        'questions' : enquete.questions,
        'initialDate' : enquete.initialDate,
        'finalDate' : enquete.finalDate
      }
    );
  }

  Future<List<EnqueteModel>> queryCloudDatabase(Coordinator coordinator)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<EnqueteModel> enquetes = [];
    await db.collection('enquetes').where("course", isEqualTo: coordinator.course).get().then((value){
      for (var enquete in value.docs) {
        debugPrint('adicionado');
        enquetes.add(
          EnqueteModel(
              uid: enquete.id,
              course: enquete['course'],
              discipline: enquete['discipline'],
              coordinator: enquete['coordinator'],
              initialDate: enquete['initialDate'],
              finalDate: enquete['finalDate'],
              questions: _dynamicListToStringList(enquete['questions'])
          )
        );
      }
    });


    return enquetes;
  }

  Future<List<EnqueteModel>> queryLocalDatabase()async{
    Database db = await startDatabase();
    List<EnqueteModel> enquetes = [];
    await db.rawQuery("SELECT * FROM enquetes").then((value){
      for (var enquete in value) {
        enquetes.add(
            EnqueteModel(
                uid: enquete['uid'].toString(),
                course: enquete['course'].toString(),
                discipline: enquete['discipline'].toString(),
                coordinator: enquete['coordinator'].toString(),
                initialDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(enquete['initialDate'].toString()))),
                finalDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(enquete['finalDate'].toString()))),
                questions: _dynamicListToStringList(jsonDecode(enquete['questions'].toString()))
            )
        );
      }
    });
    enquetes.sort((a,b)=>b.finalDate.compareTo(a.finalDate));
    return enquetes;
  }

  Future<void> deleteFromCloudDatabase(EnqueteModel enquete)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('enquetes').doc(enquete.uid).delete();
  }
  
  Future<void> insertAllLocalDatabase(List<EnqueteModel> enquetes)async{
    Database db = await startDatabase();
    String sql = '''INSERT INTO enquetes (uid, course, discipline, questions, coordinator, initialDate, finalDate) VALUES''';
    for (var enquete in enquetes) { 
      sql = "$sql('${enquete.uid}','${enquete.course}','${enquete.discipline}', '${json.encode(enquete.questions)}', '${enquete.coordinator}','${enquete.initialDate.toDate().millisecondsSinceEpoch}', '${enquete.finalDate.toDate().millisecondsSinceEpoch}'),";
    }
    sql = '${sql.substring(0,sql.length-1)};';
    
    if(enquetes.isNotEmpty)await db.execute(sql);
  }
  
  Future<void> insertLocalDatabase(EnqueteModel enquete)async{
    Database db = await startDatabase();
    String sql = '''INSERT INTO enquetes (uid, course, discipline, questions, coordinator, initialDate, finalDate) VALUES(
    '${enquete.uid}','${enquete.course}','${enquete.discipline}', '${json.encode(enquete.questions)}', '${enquete.coordinator}','${enquete.initialDate.toDate().millisecondsSinceEpoch}', '${enquete.finalDate.toDate().millisecondsSinceEpoch}'
    )''';
    await db.execute(sql);
  }

  Future<void> updateAllLocalDatabase(List<EnqueteModel> enquetes)async{
    Database db = await startDatabase();
    try{
      await db.execute('DELETE FROM enquetes');
      await insertAllLocalDatabase(enquetes);
    }finally{

    }
  }
  
  Future<void> deleteFromLocalDatabase(EnqueteModel enquete)async{
    Database db = await startDatabase();
    await db.execute("DELETE FROM enquetes WHERE uid = '${enquete.uid}'");
  }

  List<String> _dynamicListToStringList(List<dynamic> dynamicList){
    List<String> list = [];
    for (var element in dynamicList) {
      list.add(element.toString());
    }
    return list;
  }
}