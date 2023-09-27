import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/sqflite_coordinator_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

class CoordinatorControl extends SqfliteCoordinatorControler{
  
  Future<String> getCourse(String email)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String course = '';
    await db.collection('coordinators').doc(auth.currentUser!.uid).get().then((element){
      course = element.data()!['course'];
    });
    return course;
  }

  Future<String> getName(String email)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    String name = '';
    FirebaseAuth auth = FirebaseAuth.instance;
    await db.collection('coordinators').doc(auth.currentUser!.uid).get().then((element){
      name = element.data()!['name'];
    });
    return name;
  }
  
  Future<void> insertDatabase(Coordinator coordinator) async{
    Database db = await startDatabase();
    String sql = '''
      INSERT INTO coordinator (name, course, email, uid, password) VALUES(
      '${coordinator.name}',
      '${coordinator.course}',
      '${coordinator.email}',
      '${coordinator.uid}',
      '${coordinator.password}'
      )
    ''';
    try{
      await db.execute(sql);
    }finally{
      
    }
  }
  
  Future<void> updateDatabase(Coordinator coordinator)async{
    Database db = await startDatabase();
    try{
      await db.delete('coordinator');
      await insertDatabase(coordinator);
    }finally{

    }
  }
  
  Future<void> queryDatabase(Coordinator coordinator)async{
    Database db = await startDatabase();
    
    await db.rawQuery('SELECT * FROM coordinator').then((value){
      if(value.isNotEmpty){
        coordinator.name = value[0]['name']!.toString();
        coordinator.course = value[0]['course']!.toString();
        coordinator.email = value[0]['email']!.toString();
        coordinator.uid = value[0]['uid']!.toString();
        coordinator.password = value[0]['password']!.toString();
      }
    });
    
  }

  Future<void> insertCloudDatabase(Coordinator coordinator)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('coordinators').doc(coordinator.uid).set(
      {
        'name' : coordinator.name,
        'email' : coordinator.email,
        'course' : coordinator.course
      }
    );
  }
}