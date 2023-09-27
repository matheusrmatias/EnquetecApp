import 'package:enquetec/src/controllers/enquete_controller.dart';
import 'package:enquetec/src/repositories/answer_uid_repository.dart';
import 'package:enquetec/src/repositories/enquete_repository.dart';
import 'package:enquetec/src/repositories/student_repository.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:enquetec/src/widgets/enquete_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../models/student.dart';

class EnquetesTab extends StatefulWidget {
  const EnquetesTab({Key? key}) : super(key: key);

  @override
  State<EnquetesTab> createState() => _EnquetesTabState();
}

class _EnquetesTabState extends State<EnquetesTab> {
  late EnqueteRepository enqueteRep;
  late AnswerUidRepository answerUids;
  late Student student;

  @override
  Widget build(BuildContext context) {
    enqueteRep = Provider.of<EnqueteRepository>(context);
    answerUids = Provider.of<AnswerUidRepository>(context);
    student = Provider.of<StudentRepository>(context).student;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: RefreshIndicator(child: enqueteRep.enquetes.isEmpty?ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text('Não há enquetes disponíveis', style: TextStyle(color: MainColors.white)))
            ],
          ),]
      ) :ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: enqueteRep.enquetes.length,
        itemBuilder: (ctx, index)=>EnqueteCard(enquete: enqueteRep.enquetes[index]),
      ), onRefresh: ()async{
        EnqueteController control = EnqueteController();
        try{
          enqueteRep.allEnquetes = await control.queryAllCloudDatabase(student, answerUids.allUidList);
          enqueteRep.enquetes = enqueteRep.allEnquetes;
          Fluttertoast.showToast(msg: 'Enquetes Atualizadas');
        }catch (e){
          debugPrint(e.toString());
        }
      }),
    );
  }
}
