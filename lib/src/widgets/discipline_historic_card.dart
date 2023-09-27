import 'package:enquetec/src/themes/main.dart';
import 'package:enquetec/src/widgets/circle_info.dart';
import 'package:flutter/material.dart';

class DisciplineHistoricCard extends StatelessWidget {
  Map<String,String> discipline;
  DisciplineHistoricCard({required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MainColors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Flexible(child: Text(discipline['acronym']!, style: TextStyle(color: MainColors.black2, fontSize: 10))),Flexible(child: Text(discipline['period']!.substring(0, discipline['period']!.length - 1) + '-' + discipline['period']!.substring(discipline['period']!.length - 1), style: TextStyle(fontSize: 10, color: MainColors.black2)))]),
          Container(margin: const EdgeInsets.symmetric(vertical: 4),child: Row(children: [Expanded(child: Text(discipline['name']!, style:TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainColors.black2)))])),
          Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children: [
            Expanded(child: Text(discipline['observation']!, style: TextStyle(color: MainColors.black2, fontSize: 12))),
            CircleInfo(MainColors.orangeLight, title: 'Frequência', text: discipline['frequency']!.replaceAll(' ', ''), textColor: MainColors.black2),
            CircleInfo(MainColors.orange, textColor: MainColors.black2,title: 'Média', text: discipline['average']=='--'?'--':discipline['average']!.replaceAll(" ", '').length==5?discipline['average']!.toString().substring(0,discipline['average']!.length-3):discipline['average']!.toString().replaceAll(" ", "").substring(0,discipline['average']!.length-2))
          ]),

        ],
      ),
    );
  }

  _style(){
    return TextStyle(
      fontSize: 20,
      color: MainColors.white,
      fontWeight: FontWeight.bold
    );
  }
}
