import 'package:enquetec/main.dart';
import 'package:enquetec/src/admin/pages/HomeAdmin.dart';
import 'package:enquetec/src/forgot_password.dart';
import 'package:enquetec/src/pages/use_terms.dart';
import 'package:enquetec/src/widgets/login_input.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import 'themes/main.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool inLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: Container(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),color: MainColors.primary, child: GestureDetector(onTap: ()=>Navigator.pop(context),child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,children: [Icon(EvaIcons.arrowIosBackOutline, color: MainColors.orange), Flexible(child: Text('Voltar', style: TextStyle(color: MainColors.white, fontSize: 14)))])),)
    );
  }
  _body(){
    return SafeArea(child: Column(
      children: [
        Expanded(flex: 1,child: Container(alignment: Alignment.bottomCenter, child: Image.asset('assets/images/admin.png'))),
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
                      Text('Enquetec', style: TextStyle(fontSize: 32, color: MainColors.white),),
                      Text('Admin', style: TextStyle(fontSize: 32, color: MainColors.orange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                LoginInput(text: 'Email', hint: 'seu@email.com',hidden: false, icon: const Icon(Icons.email), controller: email, enable: !inLogin),
                LoginInput(text: 'Senha', hint: 'Sua Senha',hidden: true, icon: const Icon(Icons.lock), controller: password,enable: !inLogin),
                //Login Button
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),child: RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: '\nEsqueci minha senha?',
                          style: TextStyle(color: MainColors.orange, fontSize: 10),
                          recognizer: TapAndPanGestureRecognizer()
                            ..onTapUp = (e)=>Navigator.push(context, PageTransition(child: ForgotPassword(email: email.text), type:PageTransitionType.rightToLeft))
                      ),
                    ]
                ))),
                Container(margin: const EdgeInsets.symmetric(vertical: 40), child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainColors.orange,
                          disabledBackgroundColor: MainColors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: inLogin? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 32):const Text('Login',style: TextStyle(fontSize: 32))),
                )),

              ],
            ),
          ),
        )),
      ],
    ));
  }

  _login()async{
    setState(()=>inLogin=true);
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      UserCredential user = await auth.signInWithEmailAndPassword(email: email.text, password: password.text);

      if(user.user!=null){
        startAdmin(password.text);
      }
    }on FirebaseAuthException catch (e){
      if(e.code=='wrong-password'||e.code == 'invalid-email' || e.code == 'user-not-found'){
        Fluttertoast.showToast(msg: 'Senha e/ou E-mail Inválidos', backgroundColor: MainColors.orange, textColor: MainColors.white);
      }else if(e.code == 'too-many-requests'){
        Fluttertoast.showToast(msg: 'Muitas tentativas, tente novamente em alguns minutos!', backgroundColor: MainColors.orange, textColor: MainColors.white);
      }
    }
    finally{
      setState(()=>inLogin=false);
    }
  }
}


