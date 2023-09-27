import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/controllers/answer_controller.dart';
import 'package:enquetec/src/controllers/enquete_controller.dart';
import 'package:enquetec/src/models/answer.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/repositories/enquete_repository.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/enquete.dart';
import '../themes/main.dart';

class EnqueteCard extends StatefulWidget {
  final Enquete enquete;
  const EnqueteCard({Key? key, required this.enquete}) : super(key: key);

  @override
  State<EnqueteCard> createState() => _EnqueteCardState();
}

class _EnqueteCardState extends State<EnqueteCard> {
  late Student student;
  late Enquete enquete;
  late EnqueteRepository enqueteRep;
  Map<String, String> answers = {};
  bool expand = false;
  bool isSending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    enquete = widget.enquete;
    for (var element in enquete.questions) {
      answers[element]='';
    }
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    enqueteRep = Provider.of<EnqueteRepository>(context);
    return AnimatedContainer(
      curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: MainColors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        duration: const Duration(milliseconds: 300),
        child: expand?Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _enquetes(),
        ):GestureDetector(
          onTap: ()=>setState(()=>expand=!expand),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Flexible(child: Text(enquete.discipline, style: TextStyle(fontSize: 16, color: MainColors.orange, fontWeight: FontWeight.bold))),
              ]),
              Container(
                width: double.maxFinite,
                color: Colors.transparent,
                child: Icon(Icons.arrow_drop_down, color: MainColors.orange),
              )
            ],
          )
        )
    );
  }

  _enquetes(){
    List<Widget> list = [
      GestureDetector(
        onTap: ()=>setState(()=>expand=!expand),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Flexible(child: Text(enquete.discipline, style: TextStyle(fontSize: 16, color: MainColors.orange, fontWeight: FontWeight.bold))),
        ],),
      )
    ];
    for (var element in enquete.questions) {
      list.add(
        Container(margin: const EdgeInsets.symmetric(vertical: 8),child:Column(
          children: [
            Row(children: [Expanded(child: Text(element, style: TextStyle(fontSize: 16, color: MainColors.black2, fontWeight: FontWeight.bold)))]),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Column(
                    children: [
                      Radio(fillColor: MaterialStateColor.resolveWith((states) => MainColors.orange),value: 'Péssimo',groupValue: answers[element], onChanged: (value)=>setState(()=>answers[element]=value!)),
                      Text('Péssimo', style: TextStyle(color: MainColors.black2), overflow: TextOverflow.ellipsis)
                    ],
                  )),
                  Expanded(child: Column(
                    children: [
                      Radio(fillColor: MaterialStateColor.resolveWith((states) => MainColors.orange),value: 'Ruim',groupValue: answers[element], onChanged: (value)=>setState(()=>answers[element]=value!)),
                      Text('Ruim', style: TextStyle(color: MainColors.black2), overflow: TextOverflow.ellipsis)
                    ],
                  )),
                  Expanded(child: Column(
                    children: [
                      Radio(fillColor: MaterialStateColor.resolveWith((states) => MainColors.orange),value: 'Regular',groupValue: answers[element], onChanged: (value)=>setState(()=>answers[element]=value!)),
                      Text('Regular', style: TextStyle(color: MainColors.black2), overflow: TextOverflow.ellipsis)
                    ],
                  )),
                  Expanded(child: Column(
                    children: [
                      Radio(fillColor: MaterialStateColor.resolveWith((states) => MainColors.orange),value: 'Bom',groupValue: answers[element], onChanged: (value)=>setState(()=>answers[element]=value!)),
                      Text('Bom', style: TextStyle(color: MainColors.black2), overflow: TextOverflow.ellipsis)
                    ],
                  )),
                  Expanded(child: Column(
                    children: [
                      Radio(fillColor: MaterialStateColor.resolveWith((states) => MainColors.orange),value: 'Excelente',groupValue: answers[element], onChanged: (value)=>setState(()=>answers[element]=value!)),
                      Text('Excelente', style: TextStyle(color: MainColors.black2), overflow: TextOverflow.ellipsis)
                    ],
                  )),
                ],
              ),
            )
          ],
        ))
      );
    }
    list.add(
      Row(mainAxisAlignment: MainAxisAlignment.end,children: [ElevatedButton(onPressed: ()async{
        if(_validate()){
          AnswerController anwerControl = AnswerController();
          EnqueteController enqueteControl = EnqueteController();
          String uid = const Uuid().v4();
          setState(()=>isSending=true);
          try{
            Answer answer = Answer(
                uid: uid,
                enqueteUid: enquete.uid,
                studentRA: student.ra,
                dateAnswer: Timestamp.now(),
                questions: answers,
                course: enquete.course,
                coordinator: enquete.coordinator,
                discipline: enquete.discipline,
                initialDate: enquete.initialDate,
                finalDate: enquete.finalDate
            );
            await anwerControl.insertCloudDatabase(answer);
            await anwerControl.insertLocalDatabase(answer);
            await enqueteControl.deleteFromDatabase(enquete);
            enqueteRep.enquetes = await enqueteControl.queryAllLocalDatabase();
            enqueteRep.allEnquetes = enqueteRep.enquetes;
          }catch (e){
            debugPrint('ERROS: $e');
            Fluttertoast.showToast(msg: 'Erro ao enviar suas respostas.');
          }finally{
            setState(()=>isSending=false);
          }
        }else{
          Fluttertoast.showToast(msg: 'Selecione suas avalizações');
        }
      }, child:isSending? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 14) : const Text('Enviar', style: TextStyle(fontWeight: FontWeight.bold),))],)
    );

    list.add(
        GestureDetector(
            onTap: ()=>setState(()=>expand=!expand),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.transparent,
                  child: Icon(Icons.arrow_drop_up, color: MainColors.orange),
                )
              ],
            )
        )
    );

    return list;
  }

  bool _validate(){
    bool validate = false;
    int counter = 0;
    answers.forEach((key, value) {
      if(value.isNotEmpty){
        counter++;
      }
    });
    validate = counter==answers.length?true:false;

    return validate;
  }
}
