import 'package:enquetec/src/controllers/student_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/pages/account/account_page.dart';
import 'package:enquetec/src/pages/enquetes/enquetes_page.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:enquetec/src/widgets/home_navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../repositories/setting_repository.dart';
import 'account/notification_page.dart';
import 'account/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SettingRepository prefs;
  int page = 1;
  late PageController pc;
  StudentController studentControl = StudentController();
  late Student student;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pc = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    prefs = Provider.of<SettingRepository>(context);
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        toolbarHeight: 100,
        titleSpacing: 0,
        title: _header(),
        titleTextStyle: const TextStyle(overflow: TextOverflow.visible),
        backgroundColor: MainColors.black2,
        shadowColor: Colors.transparent,
      ),

      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: pc,
        onPageChanged: (value)=>setState(()=>page=value),
        children: const [
          EnquetesPage(),
          AccountPage()
        ],
      ),
      bottomNavigationBar: HomeNavigationBar(ontap: (int e) {
        pc.animateToPage(e, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        setState(()=>page=e);
      }, currentIndex: page,),
    );
  }
  _header(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      height: 100,
      color: MainColors.black2,
      child: Row(
        children: [
          Expanded(flex:4,child: Row(
            children: [
              Container(margin: const EdgeInsets.only(right: 8),height: 70, width: 70,
                child: prefs.imageDisplay?CircleAvatar(radius: 70,backgroundImage: NetworkImage(student.imageUrl),backgroundColor: MainColors.orange):CircleAvatar(radius: 70,backgroundColor: MainColors.orange, child: Icon(Icons.person, color: MainColors.white,)),
              ),const SizedBox(width: 4),Flexible(child: Text(student.name, style: TextStyle(color: MainColors.white, fontSize: 14, overflow: TextOverflow.ellipsis)))
            ],
          )),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(child: IconButton(onPressed: (){
                prefs.newNotificaiton = false;
                Navigator.push(context, PageTransition(child: const NotificationPage(), type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300)));
              }, icon: Icon(Icons.notifications, color: prefs.newNotificaiton?MainColors.orange:MainColors.white))),
              Flexible(child: IconButton(onPressed: ()=>Navigator.push(context, PageTransition(child: const SettingPage(), type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))), icon: Icon(Icons.settings, color: MainColors.white,)))
            ],
          ))
        ],
      ),
    );
  }



}
