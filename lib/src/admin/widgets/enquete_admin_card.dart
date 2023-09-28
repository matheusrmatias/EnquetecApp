import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enquetec/src/admin/controllers/result_admin_controller.dart';
import 'package:enquetec/src/admin/models/enquete_model.dart';
import 'package:enquetec/src/admin/models/result_enquete.dart';
import 'package:enquetec/src/admin/pages/result_enquete.dart';
import 'package:enquetec/src/models/cousers.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

class EnqueteAdminCard extends StatelessWidget {
  final EnqueteModel enquete;
  const EnqueteAdminCard({super.key, required this.enquete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MainColors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(Courses.names[enquete.course.toUpperCase()]!.toUpperCase(), style: TextStyle(color: MainColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(enquete.discipline, style: TextStyle(color: MainColors.white, fontSize: 16, fontWeight: FontWeight.bold)))
            ],
          ),
          Divider(color: MainColors.black2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text('Enquetes:', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold)))
            ],
          ),
          Column(
            children: enquete.questions.map((question) => Container(
              decoration: BoxDecoration(
                  color: MainColors.white2,
                  borderRadius: const BorderRadius.all(Radius.circular(4))
              ),
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Flexible(child: Text(question, style: const TextStyle(fontSize: 14)))
                ],
              ),
            )).toList(),
          ),
          Divider(color: MainColors.black2),
          Row(
            children: [
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: MainColors.white2,
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [
                        Text('Data de Envio:', style: TextStyle(fontSize: 16, color: MainColors.black)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: MainColors.grey2,),
                            const SizedBox(width: 4),
                            Flexible(child: Text(DateFormat('dd/MM/yyyy').format(enquete.initialDate.toDate()), style: TextStyle(fontSize: 16, color: MainColors.grey2)),)
                          ],
                        )
                      ],
                    ),
                  )
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: MainColors.white2,
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: [
                        Text('Data Final:', style: TextStyle(fontSize: 16, color: MainColors.black)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: MainColors.grey2,),
                            const SizedBox(width: 4),
                            Flexible(child: Text(DateFormat('dd/MM/yyyy').format(enquete.finalDate.toDate()), style: TextStyle(fontSize: 16, color: MainColors.grey2))),
                          ],
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: enquete.finalDate.millisecondsSinceEpoch>Timestamp.now().millisecondsSinceEpoch? null : ()async{
            showDialog(context: context, builder: (BuildContext context){
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Flexible(child: Text('Carregando Resultados', style: TextStyle(color: MainColors.white, fontSize: 14)))],
                  ),
                  LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 32)
                ],
              ));
            });
            try{
              ResultAdminController resultControl = ResultAdminController();
              ResultEnquete result = await resultControl.queryCloudDatabase(enquete);
              if(context.mounted){
                Navigator.pop(context);
                Navigator.push(context, PageTransition(child: ResultEnquetePage(result: result), type: PageTransitionType.rightToLeft));
              }
            }catch (e){
              debugPrint(e.toString());
              Fluttertoast.showToast(msg: 'Ocorreu um erro ao tentar obter os resultados');
              if(context.mounted){
                Navigator.pop(context);
              }
            }
          }, style: ElevatedButton.styleFrom(minimumSize: const Size(double.maxFinite, 50), shadowColor: Colors.transparent, disabledBackgroundColor: MainColors.grey2), child: const Text('RESULTADOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}

//
// class EnqueteAdminCard extends StatefulWidget {
//   final EnqueteModel enquete;
//   const EnqueteAdminCard({super.key, required this.enquete});
//
//   @override
//   State<EnqueteAdminCard> createState() => _EnqueteAdminCardState();
// }
//
// class _EnqueteAdminCardState extends State<EnqueteAdminCard> {
//   late EnqueteModel enquete;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     enquete = widget.enquete;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: MainColors.grey,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text('${Courses.names[enquete.course.toUpperCase()]!.toUpperCase()}: ', style: TextStyle(color: MainColors.black, fontSize: 14, fontWeight: FontWeight.bold)),
//               Expanded(child: Text(enquete.discipline, style: TextStyle(color: MainColors.orange, fontSize: 14, fontWeight: FontWeight.bold)))
//             ],
//           ),
//           Column(
//             children: enquete.questions.map((question) => Container(
//               decoration: BoxDecoration(
//                 color: MainColors.white2,
//                 borderRadius: const BorderRadius.all(Radius.circular(4))
//               ),
//               margin: const EdgeInsets.symmetric(vertical: 4),
//               padding: const EdgeInsets.all(4),
//               child: Row(
//                 children: [
//                   Flexible(child: Text(question, style: const TextStyle(fontSize: 12)))
//                 ],
//               ),
//             )).toList(),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: MainColors.white2,
//                         borderRadius: const BorderRadius.all(Radius.circular(10))
//                     ),
//                     child: Column(
//                       children: [
//                         Text('Data de Envio:', style: TextStyle(fontSize: 14, color: MainColors.black)),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.calendar_today, size: 14, color: MainColors.black,),
//                             const SizedBox(width: 4),
//                             Flexible(child: Text(DateFormat('dd/MM/yyyy').format(enquete.initialDate.toDate()), style: TextStyle(fontSize: 14, color: MainColors.black)),)
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: MainColors.white2,
//                         borderRadius: const BorderRadius.all(Radius.circular(10))
//                     ),
//                     child: Column(
//                       children: [
//                         Text('Data Final:', style: TextStyle(fontSize: 14, color: MainColors.black)),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.calendar_today, size: 14, color: MainColors.black,),
//                             const SizedBox(width: 4),
//                             Flexible(child: Text(DateFormat('dd/MM/yyyy').format(enquete.finalDate.toDate()), style: TextStyle(fontSize: 14, color: MainColors.black))),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ElevatedButton(onPressed: enquete.finalDate.millisecondsSinceEpoch>Timestamp.now().millisecondsSinceEpoch? null : ()async{
//             ResultAdminController resultControl = ResultAdminController();
//             ResultEnquete result = await resultControl.queryCloudDatabase(enquete);
//             Navigator.push(context, PageTransition(child: ResultEnquetePage(result: result), type: PageTransitionType.rightToLeft));
//
//           }, style: ElevatedButton.styleFrom(minimumSize: const Size(double.maxFinite, 50), shadowColor: Colors.transparent, disabledBackgroundColor: MainColors.grey2), child: const Text('Ver Resultados', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))
//         ],
//       ),
//     );
//   }
// }
