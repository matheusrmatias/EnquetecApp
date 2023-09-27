import 'package:enquetec/src/widgets/link_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../themes/main.dart';

class DeveloperContact extends StatefulWidget {
  final String name;
  const DeveloperContact({super.key, required this.name});

  @override
  State<DeveloperContact> createState() => _DeveloperContactState();
}

class _DeveloperContactState extends State<DeveloperContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('CONTATO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                LinkButton(func: ()async{
                  try{
                    await launchUrlString("mailto:contato@matheusrmatias.dev.br", mode: LaunchMode.externalApplication);
                  }catch (e){
                    Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                  }
                }, text: 'Enviar E-mail'),
                LinkButton(func: _bugReport, text: 'Relatar Problema'),
                LinkButton(func: _suggestion, text: 'Dar uma Sugestão'),
              ],
            ),
          )
        ),
      ),
    );
  }
  _bugReport(){
    TextEditingController bugReport = TextEditingController();
    showDialog(context: context, builder: (context){
      return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: MainColors.black2,
                borderRadius: const BorderRadius.all(Radius.circular(16))
            ),
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Text('Relatar Problema',style: TextStyle(color: MainColors.orange,fontSize: 16,fontWeight: FontWeight.bold)))
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
                      minLines: 10,
                      maxLines: 10,
                      controller: bugReport,
                      style: TextStyle(
                        fontSize: 12,
                        color: MainColors.black2,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Use este campo para relatar o problema',
                          hintStyle: TextStyle(color: MainColors.black2, fontSize: 14),
                          helperText: 'Esta mensagem será enviada ao desenvolvedor.',
                          helperStyle: TextStyle(color: MainColors.black2, fontSize: 12),
                          counterStyle: TextStyle(color: MainColors.black2)
                      ),
                      textAlign: TextAlign.justify,
                      onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        try{
                          await launchUrlString("mailto:enquetec.ofc+problema@gmail.com?subject=Relato%20de%20Problema&body=${bugReport.text.replaceAll(' ', '%20').replaceAll('&', '%26').replaceAll('?', '%3F').replaceAll('=', '%3D')}%0A${widget.name}%0A${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}", mode: LaunchMode.externalApplication);
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

  _suggestion(){
    TextEditingController suggestion = TextEditingController();
    showDialog(context: context, builder: (context){
      return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: MainColors.black2,
                borderRadius: const BorderRadius.all(Radius.circular(16))
            ),
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Text('Sugestão',style: TextStyle(color: MainColors.orange,fontSize: 16,fontWeight: FontWeight.bold)))
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
                      minLines: 10,
                      maxLines: 10,
                      controller: suggestion,
                      style: TextStyle(
                        fontSize: 12,
                        color: MainColors.black2,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Use este campo para dar sua sugestão',
                          hintStyle: TextStyle(color: MainColors.black2, fontSize: 14),
                          helperText: 'Esta mensagem será enviada ao desenvolvedor.',
                          helperStyle: TextStyle(color: MainColors.black2, fontSize: 12),
                          counterStyle: TextStyle(color: MainColors.black2)
                      ),
                      textAlign: TextAlign.justify,
                      onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        try{
                          await launchUrlString("mailto:enquetec.ofc+sugestao@gmail.com?subject=Sugestão&body=${suggestion.text.replaceAll(' ', '%20').replaceAll('&', '%26').replaceAll('?', '%3F').replaceAll('=', '%3D')}%0A${widget.name}%0A${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}", mode: LaunchMode.externalApplication);
                          suggestion.clear();
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
}
