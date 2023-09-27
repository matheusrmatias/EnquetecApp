import 'package:enquetec/src/admin/controllers/coordinator_controller.dart';
import 'package:enquetec/src/admin/controllers/enquetes_admin_control.dart';
import 'package:enquetec/src/admin/controllers/messages_controller.dart';
import 'package:enquetec/src/admin/controllers/notification_controller.dart';
import 'package:enquetec/src/admin/controllers/student_controller_admin.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/models/enquete_model.dart';
import 'package:enquetec/src/admin/models/message_model.dart';
import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:enquetec/src/admin/pages/HomeAdmin.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/enquete_admin_repository.dart';
import 'package:enquetec/src/admin/repositories/message_repository.dart';
import 'package:enquetec/src/admin/repositories/notification_repository.dart';
import 'package:enquetec/src/admin/repositories/student_admin_repository.dart';
import 'package:enquetec/src/admin/services/admin_notification_service.dart';
import 'package:enquetec/src/app_widget.dart';
import 'package:enquetec/src/controllers/answer_controller.dart';
import 'package:enquetec/src/controllers/enquete_controller.dart';
import 'package:enquetec/src/controllers/notification_controller.dart';
import 'package:enquetec/src/controllers/student_controller.dart';
import 'package:enquetec/src/loading_myapp.dart';
import 'package:enquetec/src/models/answer.dart';
import 'package:enquetec/src/models/enquete.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/pages/home_page.dart';
import 'package:enquetec/src/login_page.dart';
import 'package:enquetec/src/repositories/answer_repository.dart';
import 'package:enquetec/src/repositories/answer_uid_repository.dart';
import 'package:enquetec/src/repositories/enquete_repository.dart';
import 'package:enquetec/src/repositories/notification_student_repository.dart';
import 'package:enquetec/src/repositories/setting_repository.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  Provider.debugCheckInvalidValueType = null;
  runApp(const LoadingMyApp());
  await Firebase.initializeApp();

  Student student = Student(cpf: '', password: '');
  StudentController control = StudentController();
  await control.queryStudent(student);

  NotificationController controlNotif = NotificationController();
  List<NotificationModel> notification = await controlNotif.queryAllDatabase();

  Coordinator coordinator = Coordinator(email: '', course: '', name: '', uid: '', password: '');
  CoordinatorControl coordinatorControl = CoordinatorControl();
  await coordinatorControl.queryDatabase(coordinator);

  EnquetesAdminControl enquetesAdminControl = EnquetesAdminControl();
  List<EnqueteModel> enquetes = await enquetesAdminControl.queryLocalDatabase();


  MessageControl messageControl = MessageControl();
  List<Message> messages = await messageControl.queryDatabase();

  NotificationControl notificationControl = NotificationControl();
  List<NotificationModel> notifications = await notificationControl.queryDatabase();

  EnqueteController enqueteControl = EnqueteController();
  List<Enquete> enquetesStudent = await enqueteControl.queryAllLocalDatabase();

  AnswerController answerControl = AnswerController();
  List<Answer> answers = await answerControl.queryLocalDatabase();

  SharedPreferences prefs = await SharedPreferences.getInstance();


  if(student.cpf == ''){
    if(coordinator.name == ''){
      runApp(
          MultiProvider(providers: [
            Provider<StudentRepository>(create: (context)=>StudentRepository(student)),
            ChangeNotifierProvider<AnswerUidRepository>(create: (context)=>AnswerUidRepository(allUidList: answers.map((e) => e.enqueteUid).toList())),
            ChangeNotifierProvider<AnswerRepository>(create: (context)=>AnswerRepository(allAnswers: answers)),
            ChangeNotifierProvider<EnqueteRepository>(create: (context)=>EnqueteRepository(allEnquetes: enquetesStudent)),
            ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
            ChangeNotifierProvider<NotificationStudentRepository>(create: (context)=>NotificationStudentRepository(notification: notification))
          ],
            child:const MyApp(page: LoginPage()),
          )
      );
    }else{
      await AdminNotificationService().initNotifications();
      StudentControllerAdmin studentControlAdmin = StudentControllerAdmin();
      List<Student> studentsList = await studentControlAdmin.queryAllStudent();
      runApp(MultiProvider(providers: [
        ChangeNotifierProvider<StudentAdminRepository>(create: (context)=>StudentAdminRepository(allStudents: studentsList)),
        ChangeNotifierProvider<MessageRepository>(create: (context)=>MessageRepository(allMessages: messages)),
        ChangeNotifierProvider<CoordinatorRepository>(create: (context)=>CoordinatorRepository(coordinator: coordinator)),
        ChangeNotifierProvider<NotificationRepository>(create: (context)=>NotificationRepository(allNotifications: notifications)),
        ChangeNotifierProvider<EnqueteAdminRepository>(create: (context)=>EnqueteAdminRepository(allEnquetes: enquetes))
      ], child: const MyApp(page: HomeAdmin())));
    }
  }else{
    await NotificationService().initNotifications();
    runApp(
        MultiProvider(providers: [
          Provider<StudentRepository>(create: (context)=>StudentRepository(student)),
          ChangeNotifierProvider<AnswerUidRepository>(create: (context)=>AnswerUidRepository(allUidList: answers.map((e) => e.enqueteUid).toList())),
          ChangeNotifierProvider<AnswerRepository>(create: (context)=>AnswerRepository(allAnswers: answers)),
          ChangeNotifierProvider<EnqueteRepository>(create: (context)=>EnqueteRepository(allEnquetes: enquetesStudent)),
          ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
          ChangeNotifierProvider<NotificationStudentRepository>(create: (context)=>NotificationStudentRepository(notification: notification))
        ],
          child:const MyApp(page: HomePage()),
        )
    );
  }
}

void startAdmin(String password)async{
  runApp(const LoadingMyApp());
  MessageControl control = MessageControl();
  NotificationControl nControl = NotificationControl();
  CoordinatorControl coordinatorControl = CoordinatorControl();
  EnquetesAdminControl enquetesControl = EnquetesAdminControl();
  StudentControllerAdmin studentControlAdmin = StudentControllerAdmin();
  //
  try{
    //
    FirebaseAuth auth = FirebaseAuth.instance;
    String? email = auth.currentUser!.email;
    String course = await coordinatorControl.getCourse(email!);
    String name = await coordinatorControl.getName(email!);
    //
    Coordinator coordinator = Coordinator(email: email!, course: course, name: name, uid: auth.currentUser!.uid, password: password);
    List<Message> messages = await control.queryAllMessages(coordinator);
    List<NotificationModel> notifications = await nControl.queryAllNotifications(coordinator);
    List<EnqueteModel> enquetes = await enquetesControl.queryCloudDatabase(coordinator);
    enquetes.sort((a,b) => b.finalDate.compareTo(a.finalDate));

    List<Student> studentsList = await studentControlAdmin.queryAllStudent();
    //
    await AdminNotificationService().initNotifications();
    await AdminNotificationService().initTopics(coordinator);
    //
    await coordinatorControl.insertDatabase(coordinator);
    await control.insertAllDatabase(messages);
    await nControl.insertAllDatabase(notifications);
    await enquetesControl.insertAllLocalDatabase(enquetes);

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<StudentAdminRepository>(create: (context)=>StudentAdminRepository(allStudents: studentsList)),
      ChangeNotifierProvider<MessageRepository>(create: (context)=>MessageRepository(allMessages: messages)),
      ChangeNotifierProvider<CoordinatorRepository>(create: (context)=>CoordinatorRepository(coordinator: coordinator)),
      ChangeNotifierProvider<NotificationRepository>(create: (context)=>NotificationRepository(allNotifications: notifications)),
      ChangeNotifierProvider<EnqueteAdminRepository>(create: (context)=>EnqueteAdminRepository(allEnquetes: enquetes))
    ], child: const MyApp(page: HomeAdmin())));
  }catch (e){
    debugPrint('Error $e');
    Fluttertoast.showToast(msg: 'Ocoreu um erro, tente novamente');
    control.deleteDatabase();
    main();
  }
}