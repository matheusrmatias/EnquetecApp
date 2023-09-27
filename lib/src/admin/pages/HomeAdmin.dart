import 'package:enquetec/src/admin/pages/message_page.dart';
import 'package:enquetec/src/admin/pages/notifications/notification_page.dart';
import 'package:enquetec/src/admin/pages/enquete/send_enquetes_page.dart';
import 'package:enquetec/src/admin/pages/notifications/send_notification_page.dart';
import 'package:enquetec/src/admin/pages/settings/setting_page.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/widgets/home_admin_navigation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../themes/main.dart';
import '../models/coordinator_model.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int page = 1;
  late String text;
  late PageController pc;
  List<HomeAdminNavigationBarItem> items = [
    HomeAdminNavigationBarItem(
        icon: Icons.add_alert,
        text: 'Avisos'
    ),
    HomeAdminNavigationBarItem(
        icon: Icons.email,
        text: 'Mensagens'
    ),
    HomeAdminNavigationBarItem(
        icon: Icons.bar_chart,
        text: 'Enquetes'
    )
  ];
  late Coordinator coordinator;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pc = PageController(initialPage: page);
    text = items[page].text.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar:  AppBar(
          title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          actions: [IconButton(onPressed: ()=>Navigator.push(context, PageTransition(child: const SettingAdmin(), type: PageTransitionType.rightToLeft)), icon: const Icon(Icons.settings))],
          centerTitle: true,
          backgroundColor: MainColors.primary,
          shadowColor: Colors.transparent,
          toolbarHeight: 60
      ),
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: pc,
        onPageChanged: (value){
          setState(()=>page=value);
          text=items[value].text.toUpperCase();
        },
        children: const [
          SendNotificationPage(),
          MessagePage(),
          SendEnquetesPage()
        ],
      ),
      // drawer: Drawer(
      //   child: SafeArea(
      //     child: Column(
      //       children: [
      //         Expanded(flex: 1,child: Container(
      //           padding: const EdgeInsets.all(32),
      //           decoration: BoxDecoration(
      //             color: MainColors.grey,
      //             image: DecorationImage(image: Image.asset('assets/images/splash.png').image)
      //           ),
      //         )),
      //         Expanded(flex: 4,child: Container(
      //           padding: const EdgeInsets.all(16),
      //           color: MainColors.white2,
      //           child: SingleChildScrollView(
      //             child: Column(
      //               children: [
      //                 GestureDetector(
      //                   child: Row(
      //                     children: [
      //                       Icon(Icons.history),
      //                       Expanded(child: Text('Histórico de Avisos', style: TextStyle(fontSize: 16)))
      //                     ],
      //                   ),
      //                 ),
      //                 const SizedBox(height: 8),
      //                 GestureDetector(
      //                   child: Row(
      //                     children: [
      //                       Icon(Icons.history),
      //                       Expanded(child: Text('Histórico de Enquetes', style: TextStyle(fontSize: 16)))
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           )
      //         )),
      //       ],
      //     ),
      //   )
      // ),
      bottomNavigationBar: HomeAdminNavigationBar(
        onTap: (int e) {
          // pc.jumpToPage(e);
          pc.animateToPage(e, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        currentIndex: page,
        items: items,
      ),
    );
  }
  eres(){
    return BottomNavigationBar(items: [], onTap: (e){},);
  }
}
