import 'package:enquetec/main.dart';
import 'package:enquetec/src/admin/controllers/coordinator_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/pages/enquete/enquete_page.dart';
import 'package:enquetec/src/admin/pages/notifications/notification_page.dart';
import 'package:enquetec/src/admin/pages/settings/register/coordinator_register.dart';
import 'package:enquetec/src/admin/pages/settings/register/student_register.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/services/admin_notification_service.dart';
import 'package:enquetec/src/models/cousers.dart';
import 'package:enquetec/src/pages/developer_contact.dart';
import 'package:enquetec/src/pages/enquetes/enquetes_page.dart';
import 'package:enquetec/src/widgets/copy_text.dart';
import 'package:enquetec/src/widgets/navigation_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../pages/privacy_policy.dart';
import '../../../pages/use_terms.dart';
import '../../../themes/main.dart';
import 'change_password.dart';

class SettingAdmin extends StatefulWidget {
  const SettingAdmin({super.key});

  @override
  State<SettingAdmin> createState() => _SettingAdminState();
}

class _SettingAdminState extends State<SettingAdmin> {
  late Coordinator coordinator;
  bool inExit = false;
  @override
  Widget build(BuildContext context) {
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('CONFIGURAÇÕES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              CopyCard(text: coordinator.email, ico: const Icon(Icons.email_outlined)),
              NavigationButton(text: 'Alterar Senha', child: const ChangePassword()),
              Divider(color: MainColors.white2,),
              NavigationButton(text: 'Cadastrar Aluno', child: const StudentRegister()),
              NavigationButton(text: 'Cadastrar Coordenador', child: const CoordinatorRegister()),
              Divider(color: MainColors.white2,),
              NavigationButton(text: 'Histórico de Enquetes', child: const EnquetesAdminPage()),
              NavigationButton(text: 'Histórico de Notificações', child: const NotificationAdminPage()),
              Divider(color: MainColors.white2,),
              NavigationButton(text: 'Contato com o Desenvolvedor', child: DeveloperContact(name: coordinator.name)),
              NavigationButton(text: 'Termos de Uso', child: const UseTerms()),
              NavigationButton(text: 'Política de Privacidade', child: const PrivacyPolicy()),
              FutureBuilder<PackageInfo>(future: PackageInfo.fromPlatform(),builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          'Versão: ${snapshot.data!.version}', style: TextStyle(fontSize: 10, color: MainColors.white2)),
                    );
                  default:
                    return const SizedBox();
                }
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ElevatedButton(
          onPressed: ()async{
            setState(()=>inExit=true);
            try{
              CoordinatorControl coordinatorControl = CoordinatorControl();
              await coordinatorControl.deleteDatabase();
              await AdminNotificationService().endTopic(coordinator);
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
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
