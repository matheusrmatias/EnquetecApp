import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/controllers/sqlite_controller.dart';
import 'package:enquetec/src/models/answer.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:sqflite/sqflite.dart';

class AnswerController extends SqliteController{
  Future<void> insertCloudDatabase(Answer answer)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('answers').doc(answer.uid).set(
      {
        'enqueteUid':answer.enqueteUid,
        'studentRA':answer.studentRA,
        'course':answer.course,
        'coordinator':answer.coordinator,
        'discipline':answer.discipline,
        'questions':answer.questions,
        'dateAnswer':answer.dateAnswer,
        'initialDate':answer.initialDate,
        'finalDate':answer.finalDate,
      }
    );
  }

  Future<List<Answer>> queryCloudDataBase(Student student)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Answer> answers = [];
    await db.collection('answers').where('studentRA', isEqualTo: student.ra).where('finalDate', isGreaterThan: Timestamp.now()).get().then((value){
      for (var answer in value.docs) {
        answers.add(
          Answer(
              uid: answer.id,
              enqueteUid: answer['enqueteUid'],
              studentRA: answer['studentRA'],
              dateAnswer: answer['dateAnswer'],
              questions: _dynamicListToStringList(answer['questions']),
              course: answer['course'],
              coordinator: answer['coordinator'],
              discipline: answer['discipline'],
              initialDate: answer['initialDate'],
              finalDate: answer['finalDate'])
        );
      }
    });
    return answers;
  }

  @Deprecated('No need to load all answers')
  Future<List<Answer>> queryAllCloudDataBase(Student student)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Answer> answers = [];
    await db.collection('answers').where('studentRA', isEqualTo: student.ra).get().then((value){
      for (var answer in value.docs) {
        answers.add(
            Answer(
                uid: answer.id,
                enqueteUid: answer['enqueteUid'],
                studentRA: answer['studentRA'],
                dateAnswer: answer['dateAnswer'],
                questions: _dynamicListToStringList(answer['questions']),
                course: answer['course'],
                coordinator: answer['coordinator'],
                discipline: answer['discipline'],
                initialDate: answer['initialDate'],
                finalDate: answer['finalDate'])
        );
      }
    });
    return answers;
  }

  Future<void> insertAllLocalDatabase(List<Answer> answers)async{
    Database db = await startDatabase();
    if(answers.isEmpty){
      return;
    }
    String sql = 'INSERT INTO answer (uid, enqueteUid, questions, course, discipline, coordinator, dateAnswer, initialDate, finalDate) VALUES';
    for (var answer in answers) {
      sql = "$sql('${answer.uid}','${answer.enqueteUid}','${jsonEncode(answer.questions)}','${answer.course}','${answer.discipline}','${answer.coordinator}','${answer.dateAnswer.toDate().millisecondsSinceEpoch}','${answer.initialDate.toDate().millisecondsSinceEpoch}','${answer.finalDate.toDate().millisecondsSinceEpoch}'),";
    }
    sql = '${sql.substring(0,sql.length-1)};';

    await db.execute(sql);
  }

  Future<void> insertLocalDatabase(Answer answer)async{
    Database db = await startDatabase();
    String sql = '''INSERT INTO answer (uid, enqueteUid, questions, course, discipline, coordinator, dateAnswer, initialDate, finalDate) VALUES(
      '${answer.uid}','${answer.enqueteUid}','${jsonEncode(answer.questions)}','${answer.course}','${answer.discipline}','${answer.coordinator}','${answer.dateAnswer.toDate().millisecondsSinceEpoch}','${answer.initialDate.toDate().millisecondsSinceEpoch}','${answer.finalDate.toDate().millisecondsSinceEpoch}'
    )''';
    await db.execute(sql);
  }

  Future<List<Answer>> queryLocalDatabase()async{
    Database db = await startDatabase();
    List<Answer> answers = [];
    await db.rawQuery('SELECT * FROM answer').then((value){
      for (var answer in value) {
        answers.add(
            Answer(
                uid: answer['uid'].toString(),
                enqueteUid: answer['enqueteUid'].toString(),
                studentRA: answer['studentRA'].toString(),
                dateAnswer: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(answer['dateAnswer'].toString()))),
                questions: _dynamicListToStringList(jsonDecode(answer['questions'].toString())),
                course: answer['course'].toString(),
                coordinator: answer['coordinator'].toString(),
                discipline: answer['discipline'].toString(),
                initialDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(answer['initialDate'].toString()))),
                finalDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(answer['finalDate'].toString()))))
        );
      }
    });

    return answers;
  }

  Map<String, String> _dynamicListToStringList(Map<String, dynamic> dynamicList){
    Map<String,String> map = {};
    dynamicList.forEach((key, value) {
      map[key] = value.toString();
    });
    return map;
  }
}