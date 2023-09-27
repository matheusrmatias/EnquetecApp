import 'package:flutter/cupertino.dart';

import '../models/message_model.dart';

class MessageRepository extends ChangeNotifier{
  List<Message> allMessages;
  late List<Message> _messages;

  MessageRepository({required this.allMessages}){
    _messages=allMessages;
  }

  List<Message> get messages => _messages;

  set messages(List<Message> value) {
    _messages = value;
    notifyListeners();
  }

  void cleanMessages({bool listen = true}){
    _messages = allMessages;
    if(listen)notifyListeners();
  }
}