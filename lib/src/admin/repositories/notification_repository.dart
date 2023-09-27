import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationRepository extends ChangeNotifier{
  List<NotificationModel> allNotifications;
  late List<NotificationModel> _notifications;

  NotificationRepository({required this.allNotifications}){
    _notifications = allNotifications;
  }

  List<NotificationModel> get notifications => _notifications;

  set notifications(List<NotificationModel> value) {
    _notifications = value;
    notifyListeners();
  }

  void cleanNotifications({bool listen = true}){
    _notifications = allNotifications;
    if(listen)notifyListeners();
  }
}
