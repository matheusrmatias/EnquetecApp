import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:enquetec/src/controllers/enquete_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/pages/enquetes/tabs/direct_msg_tab.dart';
import 'package:enquetec/src/pages/enquetes/tabs/enquetes_tab.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../../themes/main.dart';

class EnquetesPage extends StatefulWidget {
  const EnquetesPage({Key? key}) : super(key: key);

  @override
  State<EnquetesPage> createState() => _EnquetesPageState();
}

class _EnquetesPageState extends State<EnquetesPage> {
  late Student student;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return DefaultTabController(length: 2, child: Scaffold(
      backgroundColor: MainColors.black2,
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
            padding: const EdgeInsets.only(bottom: 4),
            indicatorColor: MainColors.orange,
            labelColor: MainColors.orange,
            unselectedLabelColor: MainColors.white2
        ),
        tabBarViewProperties: const TabBarViewProperties(
            physics: BouncingScrollPhysics()
        ),
        tabs: const [
          Tab(child: Text('Enquetes', style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis,)),
          Tab(child: Text('Mensagem Direta', style: TextStyle(fontSize: 14),textAlign: TextAlign.center,)),
        ],
        views:   const [
          EnquetesTab(),
          DirectMsgTab()
        ],
      ),
    ),
    );
  }
}
