import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/sqflite_coordinator_controller.dart';
import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:sqflite/sqflite.dart';

import '../models/coordinator_model.dart';

class NotificationControl extends SqfliteCoordinatorControler{

  Future<List<NotificationModel>> queryAllNotifications(Coordinator coordinator)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<NotificationModel> notifications = [];

    await db.collection('notifications').where("course", isEqualTo: coordinator.course).get().then((value){
      for (var element in value.docs) {
        notifications.add(
          NotificationModel(uid: element.id,title: element['title'], body: element['body'], initialDate: element["initialDate"], finalDate: element['finalDate'], course: element['course'], coordinator: element['coordinator'], link: element['link'])
        );
      }
    });
    await db.collection('notifications').where("course", isEqualTo: 'TODOS').get().then((value){
      for (var element in value.docs) {
        notifications.add(
            NotificationModel(uid: element.id,title: element['title'], body: element['body'], initialDate: element["initialDate"], finalDate: element['finalDate'], course: element['course'], coordinator: element['coordinator'], link: element['link'])
        );
      }
    });
    return notifications;
  }

  Future<void> deleteNotification(NotificationModel notification)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    try{
      await db.collection('notifications').doc(notification.uid).delete();
    }catch (e){
      throw Exception('');
    }
  }

  Future<void> insertNotification(NotificationModel notification, Coordinator coordinator)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    try{
      await db.collection('notifications').doc(notification.uid).set({
        'title' : notification.title,
        'body' : notification.body,
        'initialDate' : notification.initialDate,
        'finalDate' : notification.finalDate,
        'link' : notification.link,
        'course' : notification.course,
        'coordinator' : coordinator.name
      });
    }catch (e){
      throw Exception('');
    }
  }

  Future<void> insertAllDatabase(List <NotificationModel> notification)async{
    Database db = await startDatabase();
    String sql = 'INSERT INTO notification (uid, title, body, link, coordinator, course, initialDate, finalDate) VALUES';
    for (var element in notification) {
      sql = "$sql('${element.uid}','${element.title}','${element.body}','${element.link}','${element.coordinator}','${element.course}','${element.initialDate.toDate().millisecondsSinceEpoch}','${element.finalDate.toDate().millisecondsSinceEpoch}'),";
    }
    sql = '${sql.substring(0,sql.length-1)};';
    if(notification.isNotEmpty)await db.execute(sql);
  }

  Future<void> updateAllDatabase(List<NotificationModel> notification)async{
    Database db = await startDatabase();
    try{
      await db.execute('DELETE FROM notification');
      await insertAllDatabase(notification);
    }finally{

    }
  }

  Future<void> insertDatabase(NotificationModel notification)async{
    Database db = await startDatabase();
    String sql = '''INSERT INTO notification (uid, title, body, link, coordinator, course, initialDate, finalDate) VALUES(
        '${notification.uid}','${notification.title}','${notification.body}', '${notification.link}', '${notification.coordinator}',
        '${notification.course}', '${notification.initialDate.toDate().millisecondsSinceEpoch}', '${notification.finalDate.toDate().millisecondsSinceEpoch}'
    );''';

    try{
      await db.execute(sql);
    }finally{

    }
  }

  Future<List<NotificationModel>> queryDatabase()async{
    Database db = await startDatabase();
    List<NotificationModel> notifications = [];
      await db.rawQuery('SELECT * FROM notification WHERE finalDate >= ${DateTime.now().millisecondsSinceEpoch}').then((value){
        for (var element in value) {
          notifications.add(
            NotificationModel(
                link: element['link']!.toString(),
                title: element['title']!.toString(),
                body: element['body']!.toString(),
                initialDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(element['initialDate'].toString())!)),
                finalDate: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(element['finalDate'].toString())!)),
                course: element['course']!.toString(),
                coordinator: element['coordinator']!.toString(),
                uid: element['uid']!.toString())
          );
        }
      });
    return notifications;   
  }

  Future<void> deleteFromDatabase(NotificationModel notification)async{
    Database db = await startDatabase();
    try{
      await db.execute("DELETE FROM notification WHERE uid = '${notification.uid}'");
    }finally{

    }
  }

}