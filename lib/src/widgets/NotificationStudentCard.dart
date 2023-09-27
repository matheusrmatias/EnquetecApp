import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationStudentCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationStudentCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: MainColors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(notification.title, style: TextStyle(fontSize: 18, color: MainColors.orange, fontWeight: FontWeight.bold)))
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(child: Text(notification.body, style: TextStyle(fontSize: 14, color: MainColors.black), textAlign: TextAlign.justify))
            ],
          ),
          const SizedBox(height: 8),
          notification.link.isEmpty?const SizedBox():
          GestureDetector(
              onLongPress: ()async{
                showModalBottomSheet<void>(backgroundColor: Colors.transparent,context: context, builder: (BuildContext context){
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: MainColors.black2,
                        borderRadius: const BorderRadius.all(Radius.circular(16))
                    ),
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child:Column(
                      children: [
                        Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [Expanded(child: Text('Copiado para área de transferência', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MainColors.orange))),
                          GestureDetector(onTap: ()=>Navigator.pop(context), child: const Text('Ok', style: TextStyle(fontSize: 12, color: Colors.orange,fontWeight: FontWeight.bold)))
                        ],
                      ),],
                    )
                    )
                  );
                });
                await Clipboard.setData(ClipboardData(text: notification.link));

              },
              onTap: ()async{
                try{
                  await launchUrlString(notification.link, mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation)=>ScaleTransition(scale: animation,child: child),
              child: Row(children: [const Icon(Icons.link), const SizedBox(width: 8),Flexible(child: Text(notification.link))]))),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(notification.coordinator, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              Flexible(child: Text(DateFormat('dd/MM/yyyy').format(notification.initialDate.toDate()),style: const TextStyle(fontSize: 16)))
            ],
          )
        ],
      ),
    );
  }
}

//
// class NotificationStudentCard extends StatefulWidget {
//   final NotificationModel notification;
//   const NotificationStudentCard({super.key, required this.notification});
//
//   @override
//   State<NotificationStudentCard> createState() => _NotificationStudentCardState();
// }
//
// class _NotificationStudentCardState extends State<NotificationStudentCard> {
//   bool onCopy = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: MainColors.grey,
//           borderRadius: const BorderRadius.all(Radius.circular(10))
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Flexible(child: Text(widget.notification.title, style: TextStyle(fontSize: 18, color: MainColors.orange, fontWeight: FontWeight.bold)))
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               Flexible(child: Text(widget.notification.body, style: TextStyle(fontSize: 14, color: MainColors.black), textAlign: TextAlign.justify))
//             ],
//           ),
//           const SizedBox(height: 8),
//           widget.notification.link.isEmpty?const SizedBox():
//           GestureDetector(
//               onLongPress: ()async{
//                 await Clipboard.setData(ClipboardData(text: widget.notification.link));
//                 setState(()=>onCopy=!onCopy);
//                 await Future.delayed(const Duration(milliseconds: 1500));
//                 setState(()=>onCopy=!onCopy);
//                 },
//               onTap: ()async{
//                 try{
//                   await launchUrlString(widget.notification.link, mode: LaunchMode.externalApplication);
//                 }catch (e){
//                   Fluttertoast.showToast(msg: 'Não é possível abrir o link');
//                 }
//               }, child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (child, animation)=>ScaleTransition(scale: animation,child: child),
//             child: onCopy? const Row(key: ValueKey("true"),children: [Flexible(child: Text("Copiado para área de transferência")), SizedBox(width: 8),Icon(Icons.done)]):Row(key: const ValueKey("false"),children: [const Icon(Icons.link), const SizedBox(width: 8),Flexible(child: Text(widget.notification.link))]))),
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(child: Text(widget.notification.coordinator, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
//               Flexible(child: Text(DateFormat('dd/MM/yyyy').format(widget.notification.initialDate.toDate()),style: const TextStyle(fontSize: 16)))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }


