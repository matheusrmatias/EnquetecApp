import 'package:enquetec/src/admin/controllers/coordinator_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/widgets/login_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../themes/main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  late CoordinatorRepository coordinatorRep;
  bool inChange = false;

  @override
  Widget build(BuildContext context) {
    coordinatorRep = Provider.of<CoordinatorRepository>(context);
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('ALTERAR SENHA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LoginInput(text: 'Senha Antiga', hidden: true, icon: const Icon(Icons.lock), controller: oldPassword, hint: 'Senha Antiga', backgroundColor: MainColors.grey, textColor: MainColors.white),
              Divider(color: MainColors.white),
              LoginInput(text: 'Nova Senha', hidden: true, icon: const Icon(Icons.lock), controller: newPassword, hint: 'Nova Senha', backgroundColor: MainColors.grey, textColor: MainColors.white),
              LoginInput(text: 'Confirmar Senha', hidden: true, icon: const Icon(Icons.lock), controller: confirmPassword, hint: 'Confirmar Senha', backgroundColor: MainColors.grey, textColor: MainColors.white),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 50)
                  ),
                  child: inChange? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24):Text('Confirmar', style: TextStyle(color: MainColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
  _changePassword()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    CoordinatorControl coordinatorControl = CoordinatorControl();
    if(oldPassword.text.isEmpty){
      Fluttertoast.showToast(msg: 'A senha antiga não pode ser vazia');
      return;
    }
    if(newPassword.text != confirmPassword.text){
      Fluttertoast.showToast(msg: 'As senhas não conferem');
      return;
    }
    if(newPassword.text.length < 6){
      Fluttertoast.showToast(msg: 'A senha tem que ter no mínimo 6 caracteres');
      return;
    }

    try{
      setState(()=>inChange=!inChange);
      await auth.signInWithEmailAndPassword(email: coordinatorRep.coordinator.email, password: oldPassword.text);
      auth.currentUser?.updatePassword(newPassword.text);
      oldPassword.clear();
      newPassword.clear();
      confirmPassword.clear();
      coordinatorRep.coordinator = Coordinator(email: coordinatorRep.coordinator.email, course: coordinatorRep.coordinator.course, name: coordinatorRep.coordinator.name, uid: coordinatorRep.coordinator.uid, password: newPassword.text);
      await coordinatorControl.updateDatabase(coordinatorRep.coordinator);
      Fluttertoast.showToast(msg: 'Senha alterada com sucesso');
      Navigator.pop(context);
    }catch (e){
      Fluttertoast.showToast(msg: 'Ocorreu um erro ao alterar a senha');
      debugPrint('Error: $e');
    }finally{
      setState(()=>inChange=!inChange);
    }
  }
}
