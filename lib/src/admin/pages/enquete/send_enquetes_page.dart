import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/enquetes_admin_control.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/models/enquete_model.dart';
import 'package:enquetec/src/admin/pages/enquete/enquete_page.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/enquete_admin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:uuid/uuid.dart';

import '../../../themes/main.dart';
import '../notifications/notification_page.dart';

class SendEnquetesPage extends StatefulWidget {
  const SendEnquetesPage({super.key});

  @override
  State<SendEnquetesPage> createState() => _SendEnquetesPageState();
}

class _SendEnquetesPageState extends State<SendEnquetesPage> {
  late Coordinator coordinator;
  late EnqueteAdminRepository enqueteRep;

  String currentCourse = 'Tecnologia em Análise e Desenvolvimento de Sistemas';
  List<String> coursesList = [
    'Tecnologia em Análise e Desenvolvimento de Sistemas',
  ];
  String currentDiscipline = 'Administração Geral';
  List<String> disciplinesList = [
    'Administração Geral',
    'Arquitetura e Organização de Computadores',
    'Algoritmos e Lógica de Programação',
    'Laboratório de Hardware',
    'Programação em Microinformática',
    'Inglês I',
    'Matemática Discreta',
    'Contabilidade',
    'Engenharia de Software I',
    'Linguagem de Programação',
    'Sistemas de Informação',
    'Inglês II',
    'Comunicação e Expressão',
    'Cálculo',
    'Economia e Finanças',
    'Sociedade e Tecnologia',
    'Estruturas de Dados',
    'Engenharia de Software II',
    'Interação Humano Computador',
    'Sistemas Operacionais I',
    'Inglês III',
    'Estatística Aplicada',
    'Banco de Dados',
    'Engenharia de Software III',
    'Programação Orientada a Objetos',
    'Eletiva - Linguagem de Programação VIII - Linguagem VB.NET e ASP',
    'Sistemas Operacionais II',
    'Inglês IV',
    'Metodologia da Pesquisa Científico-Tecnológica',
    'Laboratório de Banco de Dados (Escolha 1)',
    'Laboratório de Engenharia de Software',
    'Eletiva - Programação WEB',
    'Redes de Computadores',
    'Segurança da Informação',
    'Inglês V',
    'Programação Linear e Aplicações',
    'Trabalho de Graduação I',
    'Gestão de Projetos',
    'Gestão de Equipes',
    'Empreendedorismo',
    'Ética e Responsabilidade Profissional',
    'Inteligência Artificial (Escolha 3)',
    'Tópicos Especiais em Informática (Escolha 2)',
    'Gestão e Governança de Tecnologia da Informação',
    'Inglês VI',
    'Trabalho de Graduação II'
  ];

  Map<String,String> enquetesList = {};

  TextEditingController enquete = TextEditingController();

  DateTime availableDate = DateTime.now().add(const Duration(days: 7));

  bool isSending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disciplinesList.sort();
  }

  @override
  Widget build(BuildContext context) {
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    enqueteRep = Provider.of<EnqueteAdminRepository>(context);
    return Scaffold(
      backgroundColor: MainColors.black2,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: ()=>Navigator.push(context, PageTransition(child: const EnquetesAdminPage(), type: PageTransitionType.rightToLeft)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Text('Ver histórico de Enquetes', style: TextStyle(color: MainColors.orange, fontSize: 14))),
                    Icon(Icons.access_time_outlined, color: MainColors.orange, size: 12)
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              Row(
                children: [Flexible(child: Text('Selecione a disciplina:', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold)))],
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
                      menuMaxHeight: 400,
                      isExpanded: true,
                      value: currentDiscipline,
                      items: disciplinesList.map((e){
                        return DropdownMenuItem(value: e,child: Text(e,style: const TextStyle(fontSize: 14)));
                      }).toList(),
                      dropdownColor: MainColors.grey,
                      underline: const SizedBox(),
                      onChanged: (value) => setState(()=> currentDiscipline = value!),
                    ),
                  )
                  )
                ],
              ),

              const SizedBox(height: 8),
              Row(
                children: [Flexible(child: Text('Adicione a enquete:', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold)))],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: MainColors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller: enquete,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[\'\"]'))],
                      onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Como você avalia...?',
                        hintStyle: TextStyle(fontSize: 14)
                      ),
                    )
                    ),
                    IconButton(onPressed: (){
                      String uid = const Uuid().v4();
                      if(enquete.text.isNotEmpty){
                        setState(()=>enquetesList[uid]=enquete.text);enquete.clear();
                      }else{
                        Fluttertoast.showToast(msg: 'A enquete não pode ser vazia.');
                      }
                    }, icon: Icon(Icons.add,color: MainColors.orange))
                  ],
                )
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MainColors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          children: [
                            const Text('Data de Envio:', style: TextStyle(fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today, size: 12, color: MainColors.orange,),
                                const SizedBox(width: 4),
                                Text(DateFormat('dd/MM/yyyy').format(DateTime.now()), style: TextStyle(fontSize: 16, color: MainColors.orange)),
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: GestureDetector(
                        onTap: ()async{
                          DateTime? selectDate = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 1)), firstDate: DateTime.now().add(const Duration(days: 1)), lastDate: DateTime(DateTime.now().year+1));
                          if(selectDate == null) return;
                          setState(()=>availableDate = selectDate);
                          },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: MainColors.orange,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          child: Column(
                            children: [
                              const Text('Dísponível até:', style: TextStyle(fontSize: 16)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today, size: 12, color: MainColors.white,),
                                  const SizedBox(width: 4),
                                  Text(DateFormat('dd/MM/yyyy').format(availableDate), style: TextStyle(fontSize: 16, color: MainColors.white)),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ),

                ],
              ),
              enquetesList.isEmpty? SizedBox():const SizedBox(height: 8),
              enquetesList.isEmpty? SizedBox(): Row(
                children: [Flexible(child: Text('Enquetes:', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold)))],
              ),
              const SizedBox(height: 8),
              enquetesList.isEmpty? const SizedBox():Container(
                padding: const EdgeInsets.all(8),
                height: 100,
                decoration: BoxDecoration(
                    color: MainColors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child: ListView.builder(physics: const BouncingScrollPhysics(),itemCount: enquetesList.length,itemBuilder: (ctx, index){
                  return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: MainColors.white2,
                          borderRadius: const BorderRadius.all(Radius.circular(4))
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(enquetesList.values.elementAt(index), style: const TextStyle(color: Colors.black, fontSize: 14), textAlign: TextAlign.justify)),
                          const SizedBox(width: 4),
                          GestureDetector(onTap: ()=>setState(()=>enquetesList.remove(enquetesList.keys.elementAt(index))), child: const Icon(Icons.close))
                        ],
                      )
                  );
                }),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: MainColors.red, size: 10),
                  Flexible(child: Text('O limite de enquetes é 10, defina uma data de disponibilidade para as enquetes.',style: TextStyle(color: MainColors.red,fontSize: 14), textAlign: TextAlign.justify))
                ],
              )
            ],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isSending? null:(){
          showDialog(context: context, builder: (ctx){
            return AlertDialog(
              title: const Text('Confirmar envio?'),
              actions: [
                TextButton(onPressed: ()async{Navigator.pop(context);await _sendEnquete();}, child: Text('Sim')),
                TextButton(onPressed: ()=>Navigator.pop(context), child: Text('Não'))
              ],
            );
          });
        },
        backgroundColor: MainColors.orange,
        child: isSending? LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24):const Icon(Icons.send),
      ),
    );
  }

  Future<void> _sendEnquete()async{
    setState(()=>isSending=!isSending);
    EnquetesAdminControl control = EnquetesAdminControl();
    String uid = const Uuid().v4();
    EnqueteModel enqueteModel = EnqueteModel(
        uid: uid, course: currentCourse, discipline: currentDiscipline, coordinator: coordinator.name, initialDate: Timestamp.now(), finalDate: Timestamp.fromDate(availableDate), questions: enquetesList.values.map((e) => e).toList()
    );
    if(enqueteModel.questions.isNotEmpty){
      try{
        await control.insertCloudDatabase(
            enqueteModel
        );
        await control.insertLocalDatabase(enqueteModel);
        enqueteRep.allEnquetes = await control.queryLocalDatabase();
        enqueteRep.enquetes = enqueteRep.allEnquetes;
        setState(()=>enquetesList={});
        Fluttertoast.showToast(msg: 'Enquetes enviadas com sucesso.');
      }catch (e){
        debugPrint("Error: $e");
        print(FirebaseAuth.instance.currentUser!.uid);
        Fluttertoast.showToast(msg: 'Não foi possível enviar as enquetes.');
      }finally{
        setState(()=>isSending=!isSending);
      }
    }else{
      Fluttertoast.showToast(msg: 'Adicione ao menos uma enquete!');
      setState(()=>isSending=!isSending);
    }
  }

}
