import 'dart:convert';
import 'package:enquetec/src/admin/controllers/notification_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/pages/notifications/notification_page.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/notification_repository.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/notification_model.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController link = TextEditingController();
  DateTime initialDate = DateTime.now();
  bool isSending = false;
  late Coordinator coordinator;
  late NotificationRepository notificationRep;
  String currentCourse = 'todos';
  List<Map<String, String>> coursesList = [
    {
      'course' : 'Todos',
      'value' : 'todos'
    },
    {
      'course' : 'Tecnologia em Análise e Desenvolvimento de Sistemas',
      'value' : 'ads'
    },
    {
      'course' : 'Tecnologia em Gestão da Produção Industrial',
      'value' : 'gpi'
    },
    {
      'course' : 'Tecnologia em Comércio Exterior',
      'value' : 'comex'
    },
    {
      'course' : 'Tecnologia em Agronegócio',
      'value' : 'agro'
    },
    {
      'course' : 'Tecnologia em Gestão Ambiental',
      'value' : 'ga'
    }
  ];

  Map<String, String> coursesMap = {
    'ads' : 'Tecnologia em Análise e Desenvolvimento de Sistemas' ,
    'gpi':'Tecnologia em Gestão da Produção Industrial',
    'comex':'Tecnologia em Comércio Exterior',
    'ga':'Tecnologia em Gestão Ambiental',
    'agro':'Tecnologia em Agronegócio',
    'todos' : 'Todos'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notificationRep = Provider.of<NotificationRepository>(context);
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: ()=>Navigator.push(context, PageTransition(child: const NotificationAdminPage(), type: PageTransitionType.rightToLeft)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text('Ver histórico de avisos', style: TextStyle(color: MainColors.orange, fontSize: 14))),
                    Icon(Icons.access_time_outlined, color: MainColors.orange, size: 12)
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: MainColors.grey,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all()
                        ),
                        child: TextField(
                          style: TextStyle(color: MainColors.primary, fontSize: 14),
                          decoration: const InputDecoration(
                              icon: Icon(Icons.title),
                              border: InputBorder.none,
                              hintText: 'Informe o Título',
                              hintStyle: TextStyle(fontSize: 14),
                              counterText: ''
                          ),
                          maxLength: 30,
                          onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                          controller: title,
                        )),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    color: MainColors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all()
                ),
                padding: const EdgeInsets.all(8),
                child: TextField(
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: MainColors.primary, fontSize: 14),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descreva o Aviso (obrigatório)',
                      hintStyle: TextStyle(fontSize: 14),
                    counterStyle: TextStyle(fontSize: 12),
                  ),
                  controller: body,
                  minLines: 4,
                  maxLines: 4,
                  maxLength: 160,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: MainColors.grey,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all()
                  ),
                  child: TextField(
                    style: TextStyle(color: MainColors.primary, fontSize: 14),
                    decoration: const InputDecoration(
                        icon: Icon(Icons.link),
                        border: InputBorder.none,
                        hintText: 'https://www.link.com (opcional)',
                        hintStyle: TextStyle(fontSize: 14),
                        counterText: ''
                    ),
                    maxLength: 150,
                    onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                    controller: link,
                  )),
              const SizedBox(height: 8),
              Row(
                children: [Flexible(child: Text('Selecione o curso:', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold)))],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: MainColors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      value: currentCourse,
                      items: coursesList.map((e){
                        return DropdownMenuItem(value: e['value']!,child: Text(e['course']!, style: const TextStyle(fontSize: 14)));
                      }).toList(),
                      dropdownColor: MainColors.grey,
                      underline: const SizedBox(),

                      onChanged: (value) => setState(()=> currentCourse = value!),
                    ),
                  ))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                  children: [
                    Expanded(child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: MainColors.grey,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                            children: [
                              const Text('Data de Envio:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.calendar_today, color: MainColors.orange,size: 14),const SizedBox(width: 4),Flexible(child: Text(DateFormat('dd/MM/yyyy').format(initialDate), style: TextStyle(color: MainColors.orange,fontSize: 14)))],
                              )
                            ]
                        )
                    )
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: MainColors.grey,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: [
                            const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(child: Text('Disponível até:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.calendar_today, color: MainColors.orange,size: 14),const SizedBox(width: 4),Flexible(child: Text(DateFormat('dd/MM/yyyy').format(initialDate.add(const Duration(days: 56))), style: TextStyle(color: MainColors.orange,fontSize: 14)))],
                            )
                          ],
                        )
                    )
                    )
                  ]
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: MainColors.red, size: 10),
                  Flexible(child: Text('As notificações, a partir do momento que forem enviadas, ficarão disponíveis por 8 semanas para os alunos.',style: TextStyle(color: MainColors.red,fontSize: 14), textAlign: TextAlign.justify))
                ],
              )
            ],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MainColors.orange,
        onPressed: isSending?null:_sendNotification,
        child: isSending? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24):const Icon(Icons.send),
      ),
    );
  }
  _sendNotification()async{
      NotificationControl control = NotificationControl();
      if(title.text.isNotEmpty && body.text.isNotEmpty){
        if(link.text.isNotEmpty && !link.text.contains('https://')){
          Fluttertoast.showToast(msg: 'O link deve conter "https://"');
        }else{
          try{
            setState(()=>isSending=true);
            String uuid = const Uuid().v4();
            final response = await http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=${const String.fromEnvironment('cloud_messaging_key')}',
              },
              body: jsonEncode(
                <String, dynamic>{
                  'notification': <String, dynamic>{
                    'body': body.text,
                    'title': title.text,
                  },
                  'data' : <String, dynamic>{
                    'link' : link.text,
                    'coordinator' : coordinator.name,
                    'initialDate' : initialDate.millisecondsSinceEpoch,
                    'finalDate' : initialDate.add(const Duration(days: 56)).millisecondsSinceEpoch,
                    'course' : currentCourse,
                    'uid' : uuid
                  },
                  'to': '/topics/$currentCourse',
                },
              ),
            );

            if (response.statusCode == 200) {
              NotificationModel notification = NotificationModel(title: title.text, body: body.text, initialDate: Timestamp.fromDate(initialDate), finalDate: Timestamp.fromDate(initialDate.add(const Duration(days: 56))), course: 'TODOS', coordinator: coordinator.name, uid: uuid, link: link.text);
              await control.insertNotification(notification, coordinator);
              await control.insertDatabase(notification);
              List<NotificationModel> notifs = notificationRep.allNotifications;
              notifs.insert(0,notification);
              notificationRep.allNotifications = notifs;
              title.clear();
              body.clear();
              link.clear();
              Fluttertoast.showToast(msg: 'Notificação enviada com sucesso');
            }else {
              throw Exception('ERROR 404');
            }
          }catch(e){
            debugPrint('ERROR: $e');
            Fluttertoast.showToast(msg: 'Ocorreu um erro');
          }finally{
            setState(()=>isSending=false);
          }
        }

      }else{
        Fluttertoast.showToast(msg: 'O título e descrição não podem ser vazias');
      }
  }
}
