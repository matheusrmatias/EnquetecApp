import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository extends ChangeNotifier{
  SharedPreferences prefs;
  late bool? _imageDisplay;
  late bool? _newNotificaiton;

  SettingRepository({required this.prefs}){
    _imageDisplay = getBool('imageDisplay');
    _newNotificaiton = getBool('newNotification');
  }


  bool get imageDisplay => _imageDisplay==null?true:_imageDisplay!;

  set imageDisplay(bool value){
    _imageDisplay = value;
    setBool('imageDisplay', value);
    notifyListeners();
  }

  bool get newNotificaiton => _newNotificaiton==null?false:_newNotificaiton!;

  set newNotificaiton(bool value) {
    _newNotificaiton = value;
    setBool('newNotification', value);
    notifyListeners();
  }

  getBool(String key){
    if(prefs.getBool(key) == null){
      return true;
    }else{
      return prefs.getBool(key)!;
    }
  }

  setBool(String key, bool value)async{
    await prefs.setBool(key, value);
  }

}