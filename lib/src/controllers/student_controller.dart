import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/controllers/sqlite_controller.dart';
import 'package:enquetec/src/models/assessment.dart';
import 'package:enquetec/src/models/schedule.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:sqflite/sqflite.dart';

class StudentController extends SqliteController{
  StudentController();

  Future insertDatabase(Student student) async{
    Database db = await startDatabase();
    String sqlStudent = '''
       INSERT INTO student (cpf, password, name, email, ra, pp, pr, cycle, image, fatec, progress, period, graduation) VALUES (
       '${student.cpf}','${student.password}','${student.name}','${student.email}','${student.ra}','${student.pp}','${student.pr}','${student.cycle}','${student.imageUrl}',
       '${student.fatec}','${student.progress}', '${student.period}', '${student.graduation}'
       )
    ''';

    String sqlHistoric = 'INSERT INTO historic (acronym, name, period, average, frequency, absence, observation) VALUES ';
    student.historic.forEach((element) {
      sqlHistoric = "$sqlHistoric('${element['acronym']}','${element['name']}','${element['period']}','${element['average']}','${element['frequency']}','${element['asbsense']}', '${element['observation']}'),";
    });
    sqlHistoric = '${sqlHistoric.substring(0,sqlHistoric.length-1)};';

    String sqlAssessment = 'INSERT INTO assessment (acronym, teacher,name, average, frequency, absence, assessment, max_absences,total_classes, syllabus, objective) VALUES ';
    student.assessment.forEach((element) {
      sqlAssessment = "$sqlAssessment('${element.acronym}','${element.teacher}','${element.name}','${element.average}','${element.frequency}','${element.absence}','${jsonEncode(element.assessment)}', '${element.maxAbsences}','${element.totalClasses}', '${element.syllabus}', '${element.objective}'),";
    });
    sqlAssessment = '${sqlAssessment.substring(0,sqlAssessment.length-1)};';

    String sqlSchedule = 'INSERT INTO schedule (weekDay, schedule) VALUES';
    student.schedule.forEach((element) {
      sqlSchedule = "$sqlSchedule('${element.weekDay}', '${element.schedule.toString()}'),";
    });
    sqlSchedule = '${sqlSchedule.substring(0,sqlSchedule.length-1)};';

    try{
      await db.execute(sqlStudent);
      await db.execute(sqlHistoric);
      await db.execute(sqlAssessment);
      await db.execute(sqlSchedule);
    }finally{

    }
  }

  Future updateDatabase(Student student) async{
    Database db = await startDatabase();
    try{
      await db.execute('DELETE FROM student');
      await db.execute('DELETE FROM historic');
      await db.execute('DELETE FROM assessment');
      await db.execute('DELETE FROM schedule');
      await insertDatabase(student);
    }finally{

    }
  }

  Future queryStudent(Student student) async{
    Database db = await startDatabase();
    student.historic = [];
    student.assessment = [];
    student.schedule = [];
    await db.rawQuery('SELECT * FROM student').then((value){
      if(value.isEmpty){

      }else{
        student.cpf  = value[0]['cpf'].toString();
        student.password  = value[0]['password'].toString();
        student.name  = value[0]['name'].toString();
        student.email  = value[0]['email'].toString();
        student.ra  = value[0]['ra'].toString();
        student.pp  = value[0]['pp'].toString();
        student.pr  = value[0]['pr'].toString();
        student.cycle  = value[0]['cycle'].toString();
        student.imageUrl  = value[0]['image'].toString();
        student.fatec  = value[0]['fatec'].toString();
        student.progress  = value[0]['progress'].toString();
        student.graduation  = value[0]['graduation'].toString();
        student.period  = value[0]['period'].toString();
      }
    });
    await db.rawQuery('SELECT * FROM historic').then((value){
        value.forEach((element) {
          Map<String, String> hist = {};
          element.forEach((key, value) {
            hist[key] = value.toString();
          });
          student.historic.add(hist);
        });
    });

    await db.rawQuery('SELECT * FROM assessment').then((value){
      value.forEach((element) {
        DisciplineAssessment disciplineAssessment = DisciplineAssessment();
        Map<String,String> assessment = {};
        disciplineAssessment.acronym = element['acronym'].toString();
        disciplineAssessment.teacher = element['teacher'].toString();
        disciplineAssessment.name = element['name'].toString();
        disciplineAssessment.average = element['average'].toString();
        disciplineAssessment.frequency = element['frequency'].toString();
        disciplineAssessment.absence = element['absence'].toString();
        disciplineAssessment.syllabus = element['syllabus'].toString();
        disciplineAssessment.objective = element['objective'].toString();
        disciplineAssessment.maxAbsences = element['max_absences'].toString();
        disciplineAssessment.totalClasses = element['total_classes'].toString();
        Map<String, dynamic> dynamicMap = jsonDecode(element['assessment'].toString());
        dynamicMap.forEach((key, value) {
          assessment[key] = value.toString();
        });
        disciplineAssessment.assessment = assessment;
        student.assessment.add(disciplineAssessment);
      });
    });
    await db.rawQuery('SELECT * FROM schedule').then((value){
      value.forEach((element) {
        Schedule schedule = Schedule();
        schedule.weekDay = element['weekDay'].toString();
        schedule.schedule = element['schedule'].toString().substring(1,element['schedule'].toString().length-1).split('], ').map((element) {
          element = element.replaceAll('[', '').replaceAll(']', '');
          return element.split(', ');
        }).toList();
        student.schedule.add(schedule);
      });
    });

  }


  Future insertOrUpdateFirebase(Student stundent)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    QueryDocumentSnapshot<Map<String, dynamic>> doc = (await db.collection('student').where('ra', isEqualTo: stundent.ra).get()).docs.first;
    print('Data ${doc.data()}');
    // await db.collection('student').doc().set({
    //   'ra' : stundent.ra,
    //   'name' : stundent.name,
    //   'graduation' : stundent.graduation,
    //   'fatec' : stundent.fatec,
    //   'cpf' : stundent.cpf
    // });
  }

}