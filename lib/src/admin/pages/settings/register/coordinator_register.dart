import 'package:enquetec/src/admin/controllers/coordinator_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/widgets/login_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../themes/main.dart';

class CoordinatorRegister extends StatefulWidget {
  const CoordinatorRegister({super.key});

  @override
  State<CoordinatorRegister> createState() => _CoordinatorRegisterState();
}

class _CoordinatorRegisterState extends State<CoordinatorRegister> {
  TextEditingController coordinatorName = TextEditingController();
  TextEditingController coordinatorEmail = TextEditingController();
  // TextEditingController coordinatorPassword = TextEditingController();
  String currentCourse = 'Tecnologia em Análise e Desenvolvimento de Sistemas';
  List<String> coursesList = [
    'Tecnologia em Análise e Desenvolvimento de Sistemas',
    'Tecnologia em Gestão da Produção Industrial',
    'Tecnologia em Comércio Exterior',
    'Tecnologia em Agronegócio',
    'Tecnologia em Gestão Ambiental',
  ];
  bool inRegister = false;
  late Coordinator coordinator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coursesList.sort();
  }

  @override
  Widget build(BuildContext context) {
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('CADASTRAR COORDENADOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              LoginInput(text: 'Nome', hidden: false, icon: const Icon(Icons.person), controller: coordinatorName, hint: 'Nome', backgroundColor: MainColors.grey, textColor: MainColors.orange),
              LoginInput(text: 'Email', hidden: false, icon: const Icon(Icons.email), controller: coordinatorEmail, hint: 'nome@mail.com', backgroundColor: MainColors.grey, textColor: MainColors.orange),
              //LoginInput(text: 'Senha Temporária', hidden: true, icon: const Icon(Icons.lock), controller: coordinatorPassword, hint: 'senha123', backgroundColor: MainColors.grey, textColor: MainColors.orange),
              const SizedBox(height: 4),
              Row(
                children: [Flexible(child: Text('Selecione o curso:', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold)))],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: MainColors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      value: currentCourse,
                      items: coursesList.map((e){
                        return DropdownMenuItem(value: e,child: Text(e, style: const TextStyle(fontSize: 14)));
                      }).toList(),
                      dropdownColor: MainColors.grey,
                      underline: const SizedBox(),
                      onChanged: (value) => setState(()=> currentCourse = value!),
                    ),
                  )
                  )
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: (){
                  if(coordinatorName.text.isEmpty || coordinatorEmail.text.isEmpty){
                    Fluttertoast.showToast(msg: 'O nome e e-mail não podem ser vazios.');
                    return;
                  }
                  if(!coordinatorEmail.text.contains('@fatec.sp.gov.br')){
                    Fluttertoast.showToast(msg: 'O email tem que ser de dominio "@fatec.sp.gov.br"');
                    return;
                  }

                  showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: MainColors.black2,
                            borderRadius: const BorderRadius.all(Radius.circular(16))
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Row(
                                  children: [Flexible(child: Text('Confirmar dados:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MainColors.white2)))],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('Nome: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.white2)),Expanded(child: Text(coordinatorName.text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.orange)))],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('E-mail: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.white2)),Expanded(child: Text(coordinatorEmail.text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.orange)))],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('Curso: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.white2)),Expanded(child: Text(currentCourse, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.orange)))],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(child: TextButton(onPressed: (){_registerCoordinator();Navigator.pop(context);}, child: const Text('Confirmar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 50)
                ),
                child: inRegister? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24):Text('Cadastrar', style: TextStyle(color: MainColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        )
      )
    );
  }

  _registerCoordinator()async{
    setState(()=>inRegister = !inRegister);
    FirebaseAuth auth = FirebaseAuth.instance;
    CoordinatorControl coordinatorControl = CoordinatorControl();
    String password = const Uuid().v4();
    try{
      await auth.signOut();
      UserCredential user = await auth.createUserWithEmailAndPassword(email: coordinatorEmail.text, password: password).whenComplete(()async{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: this.coordinator.email, password: this.coordinator.password);
      });
      Coordinator coordinator = Coordinator(email: coordinatorEmail.text, course: currentCourse, name: coordinatorName.text, uid: user.user!.uid, password: password);
      await coordinatorControl.insertCloudDatabase(coordinator);
      Fluttertoast.showToast(msg: 'Coordenador cadastrado com sucesso');
      debugPrint(auth.currentUser!.uid);
      coordinatorName.clear();
      coordinatorEmail.clear();
    }catch (e){
      debugPrint(e.toString());
      if(auth.currentUser!.uid != coordinator.uid){
        await auth.currentUser!.delete();
      }
      Fluttertoast.showToast(msg: 'Erro ao cadastrar o coordenador');
    }finally{
      setState(()=>inRegister = !inRegister);
    }
  }
}
