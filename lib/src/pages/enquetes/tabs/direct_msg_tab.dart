import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/messages_controller.dart';
import 'package:enquetec/src/admin/models/message_model.dart';
import 'package:enquetec/src/models/cousers.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../repositories/student_repository.dart';
import '../../../themes/main.dart';

class DirectMsgTab extends StatefulWidget {
  const DirectMsgTab({Key? key}) : super(key: key);

  @override
  State<DirectMsgTab> createState() => _DirectMsgTabState();
}

class _DirectMsgTabState extends State<DirectMsgTab> {
  TextEditingController directMsg = TextEditingController();
  List<String> dropList = [
    'Sugestão','Dúvida', 'Elogio','Crítica','Exposição'
  ];
  String dropValue = 'Crítica';
  late Student student;
  bool sending = false;
  bool anonymous = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropList.sort();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: MainColors.black2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(margin: const EdgeInsets.symmetric(horizontal: 8), alignment: AlignmentDirectional.centerStart,child: Text('Selecione a Categoria', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: MainColors.orange))),
            Container(margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: AlignmentDirectional.centerStart,
              child: DropdownButton(dropdownColor: MainColors.black2,items: dropList.map((e){
              return DropdownMenuItem(value: e,child: Text(e, style: TextStyle(fontSize: 14, color: MainColors.white)),);
            }).toList(), onChanged: (value)=>setState(()=>dropValue=value!), value: dropValue,),),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: MainColors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: MainColors.orangeLight, width: 4)
              ),
              child: TextField(
                minLines: 10,
                maxLines: 10,
                controller: directMsg,
                style: TextStyle(
                    fontSize: 12,
                    color: MainColors.black2,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Use este campo para detalhar melhor seu/sua $dropValue',
                  hintStyle: TextStyle(color: MainColors.black2, fontSize: 14),
                  helperText: 'Esta mensagem será enviada ao seu coordenador.',
                  helperStyle: TextStyle(color: MainColors.black2, fontSize: 12),
                  counterStyle: TextStyle(color: MainColors.black2)
                ),
                maxLength: 500,
                textAlign: TextAlign.justify,
                onTapOutside: (e)=>FocusScope.of(context).unfocus(),
              ),
            ),
            Container(margin: const EdgeInsets.symmetric(horizontal: 8),child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [Flexible(child: Text('Anônimo', style: TextStyle(fontSize: 16, color: MainColors.white))),
                      Switch(value: anonymous, onChanged: (e)=>setState(()=>anonymous=e),activeColor: MainColors.orange)],
                  ),
                ),
                ElevatedButton(onPressed: sending?null:()async{
                  String uuid = const Uuid().v4();
                    Message message = Message(uid: uuid, text: directMsg.text, type: dropValue, name: anonymous?"Anônimo":student.name, date: Timestamp.now());
                    MessageControl control = MessageControl();
                    if(message.text.isNotEmpty){
                      setState(()=>sending=true);

                      try{
                        final response = await http.post(
                          Uri.parse('https://fcm.googleapis.com/fcm/send'),
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization': 'key=${const String.fromEnvironment('cloud_messaging_key')}',
                          },
                          body: jsonEncode(
                            <String, dynamic>{
                              'notification': <String, dynamic>{
                                'body': message.text,
                                'title': message.type,
                              },
                              'data' : <String, dynamic>{
                                'name' : message.name,
                                'date' : message.date.toDate().millisecondsSinceEpoch,
                                'uid' : uuid
                              },
                              'to': '/topics/${AdminCourses.names[student.graduation.toUpperCase()]}',
                            },
                          ),
                        );
                        await control.insertMessage(message, student);
                        Fluttertoast.showToast(msg: 'Mensagem Enviada');
                        directMsg.clear();
                      }catch (e){
                        Fluttertoast.showToast(msg: 'Ocorreu um erro');
                      }finally{
                        setState(() {
                          sending=false;
                        });
                      }
                    }else{
                      Fluttertoast.showToast(msg: 'A mensagem não pode ser vazia.');
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(80, 40),
                    maximumSize: const Size(double.maxFinite, 40),
                    disabledBackgroundColor: MainColors.orange
                  ),
                  child: sending? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24):const Text('Enviar', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

}
