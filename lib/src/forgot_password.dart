import 'package:enquetec/src/themes/main.dart';
import 'package:enquetec/src/widgets/login_input.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPassword extends StatefulWidget {
  final String email;
  const ForgotPassword({super.key, required this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool inLogin = false;
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email.text = widget.email;
  }

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
        Expanded(flex: 1,child: Container(alignment: Alignment.bottomCenter, child: Image.asset('assets/images/Forgot password-bro.png'))),
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
                      Text('Recuperação De', style: TextStyle(fontSize: 26, color: MainColors.white),),
                      Text('Senha', style: TextStyle(fontSize: 32, color: MainColors.orange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                LoginInput(text: 'Email', hint: 'seu@email.com',hidden: false, icon: const Icon(Icons.email), controller: email, enable: !inLogin),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),child: RichText(text: TextSpan(
                    children: [
                      TextSpan(
                          text: '\nAo clicar em recuperar será enviado um e-mail para recuperação de senha. ',
                          style: TextStyle(color: MainColors.orange, fontSize: 10),
                      ),
                    ]
                ))),
                //Login Button
                Container(margin: const EdgeInsets.symmetric(vertical: 40), child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColors.orange,
                        disabledBackgroundColor: MainColors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: inLogin? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 32):const Text('Recuperar',style: TextStyle(fontSize: 32))),
                )),

              ],
            ),
          ),
        )),
      ],
    ));
  }

  _login()async{
    setState(()=>inLogin = !inLogin);
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await auth.sendPasswordResetEmail(email: email.text);
      Fluttertoast.showToast(msg: 'E-mail de recuperação enviado para ${email.text}');
      email.clear();
    }catch (e){
      debugPrint('Error: $e');
      Fluttertoast.showToast(msg: 'Não foi possível enviar o e-mail de recuperação.');
    }finally{
      setState(()=>inLogin = !inLogin);
    }
  }
}
