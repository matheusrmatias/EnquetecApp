import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/sqflite_coordinator_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/models/message_model.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:sqflite/sqflite.dart';

class MessageControl extends SqfliteCoordinatorControler{

    MessageControl();
    
    Future<List<Message>> queryAllMessages(Coordinator coordinator)async{
        FirebaseFirestore db = FirebaseFirestore.instance;
        List<Message> messages = [];

        await db.collection('messages').where("course", isEqualTo: coordinator.course).get().then((value){
            for (var element in value.docs) {
                messages.add(
                    Message(uid: element.id, text: element.data()['text'], type: element.data()['type'], name: element.data()['name'], date: element.data()['date'])
                );
            }
        });
        messages.sort((a,b)=>b.date.compareTo(a.date));
        return messages;
    }


    
    Future<void> deleteMessage(Message message)async{
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('messages').doc(message.uid).delete();
    }
    
    Future<void> insertMessage(Message message, Student student)async{
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection('messages').doc(message.uid).set(
          {
              'name' : message.name,
              'text' : message.text,
              'type' : message.type,
              'date' : message.date,
              'student' : student.name,
              'course' : student.graduation
          }
        );
    }

    Future<void> insertAllDatabase(List<Message> messages)async{
      Database db = await startDatabase();

      String sql = 'INSERT INTO message (uid,name, text, type, date) VALUES';
      messages.forEach((message) {
        sql = "$sql('${message.uid}','${message.name}', '${message.text}', '${message.type}', '${message.date.toDate().millisecondsSinceEpoch}'),";
      });
      sql = '${sql.substring(0,sql.length-1)};';

      if(messages.isNotEmpty)await db.execute(sql);
    }

    Future<void> insertDatabase(Message message)async{
      Database db = await startDatabase();
      String sql = '''INSERT INTO message (uid,name, text, type, date) VALUES(
        '${message.uid}','${message.name}', '${message.text}', '${message.type}', '${message.date.toDate().millisecondsSinceEpoch}'
      )''';

      try{
        await db.execute(sql);
      }finally{

      }
    }

    Future<List<Message>> queryDatabase()async{
      Database db = await startDatabase();
      List<Message> messages = [];
      await db.rawQuery('SELECT * FROM message').then((value){
        for (var element in value) {
          messages.add(
            Message(
                uid: element['uid']!.toString(),
                text: element['text']!.toString(),
                type: element['type']!.toString(),
                name: element['name']!.toString(),
                date: Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(int.parse(element['date']!.toString()))))
          );
        }
      });

      return messages;
    }

    Future<void> updateAllDatabase(List<Message> messages)async{
      Database db = await startDatabase();
      try{
        await db.execute('DELETE FROM message');
        await insertAllDatabase(messages);
      }finally{

      }
    }


    Future<void> deleteFromDatabase(Message message)async{
      Database db = await startDatabase();
      try{
        db.rawQuery("DELETE FROM message WHERE uid='${message.uid}'");
      }finally{

      }
    }
}