import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../themes/main.dart';

class LoginInput extends StatefulWidget {
  final String text;
  final bool hidden;
  final Icon icon;
  final String hint;
  final TextInputType type;
  final TextEditingController controller;
  bool enable;
  int lenght;
  Color backgroundColor;
  Color textColor;
  LoginInput({Key? key, required this.text, required this.hidden, required this.icon, required this.controller, required this.hint, this.type = TextInputType.text, this.lenght = 0, this.enable = true, this.backgroundColor = Colors.white, this.textColor = Colors.white}) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  bool obscure = true;
  bool focus = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {_onFocusChange();});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 4),child: Row(children: [Text(widget.text,style: TextStyle(fontSize: 16, color: widget.textColor, fontWeight: FontWeight.bold))],),),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(children: [Expanded(child: TextField(
              inputFormatters: widget.type==TextInputType.number?[FilteringTextInputFormatter.allow(RegExp("[0-9]"))]:null,
              obscureText: widget.hidden?obscure:false,
              maxLength: widget.lenght>0?widget.lenght:null,
              keyboardType: widget.type,
              controller: widget.controller,
              onTap: ()=>setState(()=>focus=true),
              autofillHints: widget.type==TextInputType.number?[AutofillHints.username]:[AutofillHints.password],
              onTapOutside: (e){FocusScope.of(context).unfocus();setState(()=>focus=false);},
              enabled: widget.enable,
              focusNode: _focusNode,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(border: InputBorder.none, hintText: widget.hint, icon: widget.icon, counterText: ''),
            )), if(widget.hidden)IconButton(onPressed: widget.enable?()=>setState(()=>obscure=!obscure):null, icon: obscure?Icon(EvaIcons.eyeOff,color: focus?MainColors.orange:Colors.grey,):Icon(EvaIcons.eye, color: focus?MainColors.orange:Colors.grey,))],),
          )
        ],
      )
    );
  }

  _onFocusChange(){
    if(_focusNode.hasFocus){
      setState(()=>focus=true);
    }else{
      setState(()=>focus=false);
    }
  }
}
