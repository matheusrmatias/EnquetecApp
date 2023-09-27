import 'package:enquetec/src/admin/controllers/messages_controller.dart';
import 'package:enquetec/src/admin/repositories/message_repository.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../models/message_model.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  MessageCard({super.key, required this.message});
  late MessageRepository messageRep;

  @override
  Widget build(BuildContext context) {
    messageRep = Provider.of<MessageRepository>(context);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: MainColors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(message.type, style: TextStyle(color: MainColors.orange, fontSize: 16,  fontWeight: FontWeight.bold))),
                  Flexible(child: Text(message.name.split(" ")[0], style: TextStyle(color: MainColors.white, fontSize: 14,  fontWeight: FontWeight.bold)))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                  children: [
                    Expanded(child: Text(message.text, textAlign: TextAlign.justify,style: const TextStyle(fontSize: 14)))
                  ]
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(child: Text(DateFormat('dd/MM/yyyy HH:mm').format(message.date.toDate()), style: TextStyle(color: MainColors.grey2, fontSize: 12,  fontWeight: FontWeight.bold))),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: MainColors. black2,
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: IconButton(onPressed: ()async{
            MessageControl control = MessageControl();
            try{
              await control.deleteFromDatabase(message);
              await control.deleteMessage(message);
              messageRep.allMessages = await control.queryDatabase();
              messageRep.messages = messageRep.allMessages;
            }catch (e){
              debugPrint(e.toString());
              Fluttertoast.showToast(msg: 'Não foi possível excluir a mensagem');
            }

          }, icon: Icon(UniconsLine.trash, color: MainColors.orange, size: 20)),
        )
      ],
    );
  }
}
