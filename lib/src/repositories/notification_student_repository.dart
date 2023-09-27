import 'package:flutter/cupertino.dart';

import '../admin/models/notification_model.dart';

class NotificationStudentRepository extends ChangeNotifier{
  late List<NotificationModel> _notifications;

  NotificationStudentRepository({required List<NotificationModel> notification}){
    _notifications = notification;
  }

  List<NotificationModel> get notifications => _notifications;

  set notifications(List<NotificationModel> value) {
    _notifications = value;
    notifyListeners();
  }
}