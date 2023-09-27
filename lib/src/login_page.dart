import 'package:enquetec/src/controllers/answer_controller.dart';
import 'package:enquetec/src/controllers/enquete_controller.dart';
import 'package:enquetec/src/controllers/notification_controller.dart';
import 'package:enquetec/src/controllers/student_controller.dart';
import 'package:enquetec/src/login_admin.dart';
import 'package:enquetec/src/pages/home_page.dart';
import 'package:enquetec/src/pages/use_terms.dart';
import 'package:enquetec/src/repositories/answer_repository.dart';
import 'package:enquetec/src/repositories/answer_uid_repository.dart';
import 'package:enquetec/src/repositories/enquete_repository.dart';
import 'package:enquetec/src/repositories/notification_student_repository.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/services/notification_service.dart';
import 'package:enquetec/src/services/student_account.dart';
import 'package:enquetec/src/models/student.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:enquetec/src/widgets/login_input.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController cpf = TextEditingController();
  TextEditingController password = TextEditingController();
  bool inLogin = false;
  String information = '';
  int counter = 0;
  late AnswerUidRepository answerUids;
  late StudentRepository studentRep;
  late NotificationStudentRepository notify;
  late EnqueteRepository enquetesRep;
  late AnswerRepository answerRep;
  TextEditingController bugReport = TextEditingController();

  @override
  Widget build(BuildContext context) {
    studentRep = Provider.of<StudentRepository>(context);
    notify = Provider.of<NotificationStudentRepository>(context);
    enquetesRep = Provider.of<EnqueteRepository>(context);
    answerRep = Provider.of<AnswerRepository>(context);
    answerUids = Provider.of<AnswerUidRepository>(context);
    return Scaffold(
      body: _body(),
      bottomNavigationBar: Container(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),color: MainColors.primary, child: GestureDetector(onTap: inLogin?null:()=>Navigator.push(context, PageTransition(child: const LoginAdmin(), type: PageTransitionType.rightToLeft)),child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end,children: [Flexible(child: Text('Sou Coordenador', style: TextStyle(color: MainColors.white, fontSize: 14))), Icon(EvaIcons.arrowIosForwardOutline, color: MainColors.orange)])),)
    );
  }

  _body(){
    return SafeArea(child: Column(
      children: [
        Expanded(flex: 1,child: Container(alignment: Alignment.bottomCenter,child: Image.asset('assets/images/Opinion-pana.png'))),
        Expanded(flex: 2,child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: MainColors.primary,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(60))
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  alignment: AlignmentDirectional.topStart,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bem-Vindo ao,', style: TextStyle(fontSize: 32, color: MainColors.white)),
                      Text('Enquetec', style: TextStyle(fontSize: 32, color: MainColors.orange, fontWeight: FontWeight.bold))
                    ]
                  ),
                ),
                LoginInput(text: 'CPF', hint: '00000000000',hidden: false, icon: const Icon(Icons.person), controller: cpf, type: TextInputType.number,lenght: 11, enable: !inLogin,),
                LoginInput(text: 'Senha', hint: 'Sua Senha',hidden: true, icon: const Icon(Icons.lock), controller: password,enable: !inLogin),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),child: RichText(text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Este app utiliza o SIGA para funcionar, ao informar seu CPF e sua senha do SIGA para efetuar o login você concorda com os ',
                      style: TextStyle(color: MainColors.white, fontSize: 10),
                    ),
                    TextSpan(
                      text: 'Termos de Uso',
                      style: TextStyle(color: MainColors.orange, fontSize: 10),
                      recognizer: TapAndPanGestureRecognizer()
                        ..onTapUp = (e)=>Navigator.push(context, PageTransition(child: const UseTerms(), type:PageTransitionType.rightToLeft))
                    ),
                    TextSpan(
                      text: '.',
                      style: TextStyle(color: MainColors.white, fontSize: 10),
                    )
                  ]
                ))),
                //Login Button
                Container(margin: const EdgeInsets.symmetric(vertical: 40), child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(onPressed: !inLogin?(){
                    if(cpf.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Informe o CPF');
                    }else if(password.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Informe a Senha');
                    }else if(cpf.text.length<10 || cpf.text.length>11){
                      Fluttertoast.showToast(msg: 'Informe um CPF válido');
                    }else{
                      _login();
                    }
                  }:null, style: ElevatedButton.styleFrom(

                  backgroundColor: MainColors.orange,
                  disabledBackgroundColor: MainColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 8)
                  ), child: inLogin? Column(children: [LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 32),if(information!='') Text(information, style: TextStyle(color: MainColors.white, fontSize: 12))]): const Text('Login',style: TextStyle(fontSize: 32)))
                )),
              ],
            ),
          ),
        )),
      ],
    ));
  }

  _login() async{
    counter++;
    setState(()=>inLogin=true);
    StudentAccount account = StudentAccount();
    Student student = Student(cpf: cpf.text, password: password.text);
    StudentController control = StudentController();
    NotificationController controlNotif = NotificationController();
    EnqueteController enqueteControl = EnqueteController();
    AnswerController answerControl = AnswerController();
    FirebaseAuth auth = FirebaseAuth.instance;

    try{
      // Navigator.push(context, PageTransition(child: TestePage(web: account.view), type: PageTransitionType.fade));
      setState(()=>information='Carregando Dados');
      await account.userLogin(student);
      setState(()=>information='Carregando Histórico');
      await account.userHistoric(student);
      setState(()=>information='Carregando Notas');
      await account.userAssessment(student);
      setState(()=>information='Carregando Horários');
      await account.userSchedule(student);
      setState(()=>information='Carregando Faltas');
      await account.userAbsences(student);
      setState(()=>information='Carregando Ementas');
      await account.userAssessmentDetails(student);
      // Navigator.pop(context);

      // Firebase Anonymus Auth
      UserCredential user =  await auth.signInWithEmailAndPassword(email: student.email, password: student.ra);
      if(user.user == null){
        throw Exception('Student not register');
      }

      //Update Providers
      answerRep.answers = await answerControl.queryCloudDataBase(student);
      answerRep.allAnswers = answerRep.answers;
      answerUids.allUidList = answerRep.allAnswers.map((e) => e.enqueteUid).toList();
      answerUids.uidList = answerUids.allUidList;
      debugPrint('Answers Loaded');

      enquetesRep.enquetes =  await enqueteControl.queryAllCloudDatabase(student, answerRep.allAnswers.map((e) => e.enqueteUid).toList());
      enquetesRep.allEnquetes = enquetesRep.enquetes;
      debugPrint('Enquetes Loaded');

      studentRep.student = student;

      notify.notifications = await controlNotif.queryFirebase(student);

      // Initialize Notifications
      await NotificationService().initTopics(student);

      // Local Inserts
      await enqueteControl.insertAllLocalDatabase(enquetesRep.enquetes);
      await answerControl.insertAllLocalDatabase(answerRep.answers);
      await controlNotif.insertAllDatabase(notify.notifications);
      await control.insertDatabase(student);
      if(context.mounted){
        Navigator.pushReplacement(context, PageTransition(child: const HomePage(), type: PageTransitionType.fade));
      }
      }catch(e){
        debugPrint('Error $e');
        if(e.toString() == 'Exception: User or Password Incorrect'){
        Fluttertoast.showToast(msg: 'Senha e/ou CPF Inválidos', backgroundColor: MainColors.orange, textColor: MainColors.white);
      }else{
        Fluttertoast.showToast(msg: 'Ocorreu um erro, tente novamente!', backgroundColor: MainColors.orange, textColor: MainColors.white);
      }
        if(counter>=3){
          showDialog(context: context, builder: (context){
            return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: MainColors.black2,
                      borderRadius: const BorderRadius.all(Radius.circular(16))
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: Text('Erro ao Entrar',style: TextStyle(color: MainColors.orange,fontSize: 16,fontWeight: FontWeight.bold)))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(child: Text('Se não consegue fazer login verifique:',style: TextStyle(color: MainColors.white)))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(child: Text('- Conexão com a internet',style: TextStyle(color: MainColors.white)))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(child: Text('- Se o SIGA está funcionando',style: TextStyle(color: MainColors.white)))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(child: Text('Caso nenhuma das opções acima, nos relate:',style: TextStyle(color: MainColors.white)))
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MainColors.grey,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: TextField(
                            minLines: 5,
                            maxLines: 5,
                            controller: bugReport,
                            style: TextStyle(
                              fontSize: 12,
                              color: MainColors.black2,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Use este campo para relatar o bug',
                                hintStyle: TextStyle(color: MainColors.black2, fontSize: 14),
                                helperText: 'Esta mensagem será enviada ao desenvolvedor.',
                                helperStyle: TextStyle(color: MainColors.black2, fontSize: 12),
                                counterStyle: TextStyle(color: MainColors.black2)
                            ),
                            maxLength: 500,
                            textAlign: TextAlign.justify,
                            onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(onPressed: ()async{
                              try{
                                await launchUrlString("mailto:enquetec.ofc+bug@gmail.com?subject=Relato%20de%20Bug&body=${bugReport.text.replaceAll(' ', '%20').replaceAll('&', '%26').replaceAll('?', '%3F').replaceAll('=', '%3D')}", mode: LaunchMode.externalApplication);
                                bugReport.clear();
                                if(mounted)Navigator.pop(context);
                              }catch (e){
                                debugPrint('Error $e');
                                Fluttertoast.showToast(msg: 'Ocorreu um erro.');
                              }
                            }, child: const Text('Enviar'))
                          ],
                        )
                      ],
                    ),
                  ),
                )
            );
          });
        }
    }finally{
      setState(()=>information='');
      setState(()=>inLogin=false);
    }
  }
}