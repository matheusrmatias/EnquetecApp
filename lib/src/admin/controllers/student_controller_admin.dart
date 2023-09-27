
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/student.dart';

class StudentControllerAdmin{
  Future<void> insertStudent(Student student,String uid)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('students').doc(uid).set({
      'name' : student.name,
      'email' : student.email,
      'ra' : student.ra
    });
  }

  Future<void> deleteStudent(Student student, Coordinator coordinator)async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: student.email, password: student.ra).whenComplete(()async{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: coordinator.email, password: coordinator.password);
    });

    await user.user!.delete();

    await db.collection('students').doc(user.user!.uid).delete();
  }

  Future<List<Student>> queryAllStudent() async {
    List<Student> students = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> studentSnapshot = await db.collection('students').get();

    for (var element in studentSnapshot.docs) {
      Student student = Student(cpf: '', password: '');
      student.ra = element['ra'];
      student.name = element['name'];
      student.email = element['email'];
      students.add(student);
    }

    return students;
  }
}