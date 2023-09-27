import 'package:enquetec/src/admin/models/result_enquete.dart';
import 'package:enquetec/src/admin/widgets/graph_enquete.dart';
import 'package:flutter/material.dart';

import '../../themes/main.dart';

class ResultEnquetePage extends StatefulWidget {
  final ResultEnquete result;
  const ResultEnquetePage({super.key, required this.result});

  @override
  State<ResultEnquetePage> createState() => _ResultEnquetePageState();
}

class _ResultEnquetePageState extends State<ResultEnquetePage> {
  late ResultEnquete result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = widget.result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('Resultado da Enquete', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
        child: result.questionsResult.isEmpty? Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('Nenhum resultado encontrado', style: TextStyle(color: MainColors.white, fontSize: 14)))]):ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: result.questionsResult.length,
            itemBuilder: (ctx, index){
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: GraphEnquete(result: result.questionsResult[result.questionsResult.keys.toList()[index]], question: result.questionsResult.keys.toList()[index]),
              );
            }
        )
      ),
    );
  }
}
