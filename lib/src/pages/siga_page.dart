import 'package:enquetec/src/controllers/student_controller.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../repositories/student_repository.dart';

class SigaPage extends StatefulWidget {
  const SigaPage({super.key});

  @override
  State<SigaPage> createState() => _SigaPageState();
}

class _SigaPageState extends State<SigaPage> {
  Student student = Student(cpf: '', password: '');
  StudentController control = StudentController();
  WebViewController controller = WebViewController()
    ..loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(MainColors.primary);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.setNavigationDelegate(NavigationDelegate(
        onPageFinished: (e)async{
          if(e=='https://siga.cps.sp.gov.br/aluno/login.aspx'){
            await control.queryStudent(student);
            await controller.runJavaScript("document.getElementById('vSIS_USUARIOID').value='${student.cpf}'");
            await controller.runJavaScript("document.getElementById('vSIS_USUARIOSENHA').value='${student.password}'");
            await controller.runJavaScript("document.getElementsByName('BTCONFIRMA')[0].click()");
          }
        }
    ));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MainColors.primary,
      appBar: AppBar(
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
        shadowColor: Colors.transparent,
        title: const Text('SIGA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
      body: WebViewWidget(controller: controller),
      bottomNavigationBar: Container(
        color: MainColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: ()async{await controller.goBack();}, icon: Icon(Icons.arrow_back, color: MainColors.white,)),
            IconButton(onPressed: (){controller.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/home.aspx'));}, icon: Icon(Icons.home, color: MainColors.white,)),
            IconButton(onPressed: ()async{await controller.goForward();}, icon: Icon(Icons.arrow_forward, color: MainColors.white,)),
          ],
        ),
      )
    );
  }
}
