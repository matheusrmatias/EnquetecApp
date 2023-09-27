import 'package:enquetec/main.dart';
import 'package:enquetec/src/controllers/notification_controller.dart';
import 'package:enquetec/src/controllers/student_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/pages/account/configs/display_settings_page.dart';
import 'package:enquetec/src/login_page.dart';
import 'package:enquetec/src/pages/developer_contact.dart';
import 'package:enquetec/src/pages/privacy_policy.dart';
import 'package:enquetec/src/pages/siga_page.dart';
import 'package:enquetec/src/pages/use_terms.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/services/notification_service.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:enquetec/src/widgets/copy_text.dart';
import 'package:enquetec/src/widgets/link_button.dart';
import 'package:enquetec/src/widgets/navigation_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  StudentController control = StudentController();
  bool inExit = false;
  late Student student;
  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('CONFIGURAÇÕES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            CopyCard(text: student.ra, ico: const Icon(UniconsLine.graduation_cap)),
            CopyCard(text: student.email, ico: const Icon(UniconsLine.envelope)),
            NavigationButton(text: 'Config. de Exibição', child: const DisplaySettingPage()),
            NavigationButton(text: 'Contato com o Desenvolvedor', child: DeveloperContact(name: student.name)),
            NavigationButton(text: 'Termos de Uso', child: const UseTerms()),
            NavigationButton(text: 'Política de Privacidade', child: const PrivacyPolicy()),
            NavigationButton(text: 'Acessar o Siga', child: const SigaPage()),
            FutureBuilder<PackageInfo>(future: PackageInfo.fromPlatform(),builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Versão: ${snapshot.data!.version}', style: TextStyle(fontSize: 10, color: MainColors.white)),
                  );
                default:
                  return const SizedBox();
              }
            })
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ElevatedButton(
          onPressed: ()async{
            FirebaseAuth auth = FirebaseAuth.instance;
            setState(()=>inExit=true);
            try{
              await NotificationService().endTopic(student);
              auth.signOut();
              await control.deleteDatabase();
              main();
            }catch (e){
              Fluttertoast.showToast(msg: 'Não foi possível sair. Verifique sua conexão de internet');
            }finally{
              setState(()=>inExit=false);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, double.maxFinite),
          ),
          child: inExit?LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 32):const Text('Sair',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
