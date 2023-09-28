import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:enquetec/src/controllers/sqlite_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class NotificationController extends SqliteController{
  NotificationController();

  Future<void> insertDatabase(NotificationModel notification)async{
    Database db = await startDatabase();
    String sql = '''INSERT INTO notification (uid,title, body, link, course, coordinator, finalDate, initialDate) VALUES(
      '${notification.uid}', '${notification.title}', '${notification.body}', '${notification.link}', '${notification.course}', '${notification.coordinator}', ${notification.finalDate.toDate().millisecondsSinceEpoch}, ${notification.initialDate.toDate().millisecondsSinceEpoch}
    )''';
    await db.execute(sql);
    debugPrint('insert notification');
  }

  Future<void> insertAllDatabase(List<NotificationModel> notifications)async{
    Database db = await startDatabase();
    String sql = 'INSERT INTO notification (uid,title, body, link, course, coordinator, finalDate, initialDate) VALUES ';
    for (var element in notifications) {
      sql = "$sql('${element.uid}', '${element.title}', '${element.body}', '${element.link}', '${element.course}', '${element.coordinator}', ${element.finalDate.toDate().millisecondsSinceEpoch}, ${element.initialDate.toDate().millisecondsSinceEpoch}),";
    }
    sql = '${sql.substring(0, sql.length-1)};';
    if(notifications.isNotEmpty) await db.rawQuery(sql);

  }
  Future<void> updateAllDatabase(List <NotificationModel> notification)async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM notification');
    await insertAllDatabase(notification);

  }

  Future<List<NotificationModel>> queryAllDatabase()async{
    Database db = await startDatabase();
    List<NotificationModel> notifications = [];
    await db.rawQuery('SELECT * FROM notification WHERE finalDate >= ${DateTime.now().millisecondsSinceEpoch}').then((value){
      for (var element in value) {
        notifications.add(
          NotificationModel(
              link: element['link'].toString(),
              title: element['title'].toString(),
              body: element['body'].toString(),
              initialDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(element['initialDate'].toString())!)),
              finalDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(element['finalDate'].toString())!)),
              course: element['course'].toString(),
              coordinator: element['coordinator'].toString(),
              uid: element['uid'].toString())
        );
      }});
    return notifications;
  }

  Future<List<NotificationModel>> queryFirebase(Student student)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<NotificationModel> notifications = [];
    await db.collection('notifications').where('finalDate', isGreaterThanOrEqualTo: Timestamp.now()).where('course', whereIn: [student.graduation, 'TODOS']).get().then((value){
      for (var element in value.docs) {
        notifications.add(
          NotificationModel(
              link: element.data()['link'],
              title: element.data()['title'],
              body: element.data()['body'],
              initialDate: element.data()['initialDate'],
              finalDate: element.data()['finalDate'],
              course: element.data()['course'],
              coordinator: element.data()['coordinator'],
              uid: element.id)
        );
      }
    });
    notifications.sort((a,b)=> b.initialDate.compareTo(a.initialDate));
    return notifications;
  }

  Future<void> cleanDatabase()async{
    Database db = await startDatabase();
    await db.rawQuery('DELETE FROM notification WHERE finalDate<${DateTime.now().millisecondsSinceEpoch}');
  }
  
}