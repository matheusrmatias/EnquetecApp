import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/controllers/sqlite_controller.dart';
import 'package:sqflite/sqflite.dart';
import '../models/enquete.dart';
import '../models/student.dart';

class EnqueteController extends SqliteController{

  Future<List<Enquete>> queryAllCloudDatabase(Student student, List<String> uids)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Enquete> enquetes = [];

    await db.collection('enquetes').where('course', isEqualTo: student.graduation).where('discipline', whereIn: student.assessment.map((e) => e.name)).where('finalDate', isGreaterThan: Timestamp.now()).get().then((value){
      for (var enquete in value.docs) {
        if(!uids.contains(enquete.id)){
          enquetes.add(
              Enquete(
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
      }
    });

    return enquetes;
  }

  Future<void> insertAllLocalDatabase(List<Enquete> enquetes)async{
    if(enquetes.isEmpty){
      return;
    }
    Database db = await startDatabase();
    String sql = '''INSERT INTO enquete (uid, course, discipline, questions, coordinator, initialDate, finalDate) VALUES''';
    for (var enquete in enquetes) {
      sql = "$sql('${enquete.uid}','${enquete.course}','${enquete.discipline}', '${json.encode(enquete.questions)}', '${enquete.coordinator}','${enquete.initialDate.toDate().millisecondsSinceEpoch}', '${enquete.finalDate.toDate().millisecondsSinceEpoch}'),";
    }
    sql = '${sql.substring(0,sql.length-1)};';

    await db.execute(sql);
  }

  Future<List<Enquete>> queryAllLocalDatabase()async{
    Database db = await startDatabase();
    List<Enquete> enquetes = [];
    await db.rawQuery("SELECT * FROM enquete").then((value){
      for (var enquete in value) {
        enquetes.add(
            Enquete(
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
    enquetes.sort((a,b)=>a.finalDate.compareTo(b.finalDate));
    return enquetes;
  }

  Future<void> updateLocalDatabase(List<Enquete> enquetes) async{
    Database db = await startDatabase();
    await db.delete('DELETE FROM enquete');
    await insertAllLocalDatabase(enquetes);
  }

  Future<void> deleteFromDatabase(Enquete enquete)async{
    Database db = await startDatabase();
    await db.execute("DELETE FROM enquete WHERE uid = '${enquete.uid}'");
  }

  List<String> _dynamicListToStringList(List<dynamic> dynamicList){
    List<String> list = [];
    for (var element in dynamicList) {
      list.add(element.toString());
    }
    return list;
  }
}