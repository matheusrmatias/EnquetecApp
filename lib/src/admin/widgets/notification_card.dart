import 'package:enquetec/src/admin/controllers/notification_controller.dart';
import 'package:enquetec/src/admin/models/notification_model.dart';
import 'package:enquetec/src/admin/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';


import '../../themes/main.dart';

//ignore: must_be_immutable
class NotificationCard extends StatelessWidget {
  NotificationModel notification;
  NotificationCard({super.key, required this.notification});
  late NotificationRepository notificationRep;

  @override
  Widget build(BuildContext context) {
    notificationRep = Provider.of<NotificationRepository>(context, listen: true);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              color: MainColors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child:Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text(notification.title, style: TextStyle(color: MainColors.orange, fontSize: 16,  fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 8),
              Row(children: [Flexible(child: Text(notification.body,style: const TextStyle(fontSize: 14), textAlign: TextAlign.justify))]),
              Divider(color: MainColors.black2),
              notification.link.isEmpty?const SizedBox(height: 8):Row(children: [const Icon(Icons.link, color: Colors.orange,), const SizedBox(width: 8),Flexible(child: Text(notification.link, style: TextStyle(color: MainColors.orange, fontWeight: FontWeight.bold)))]),
              notification.link.isEmpty?const SizedBox():const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Início: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.initialDate.toDate())}', style: TextStyle(color: MainColors.grey2, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Término: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.finalDate.toDate())}', style: TextStyle(color: MainColors.grey2, fontSize: 12, fontWeight: FontWeight.bold))
                    ],
                  )),

                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: MainColors.black2,
              borderRadius: const BorderRadius.all(Radius.circular(100))
          ),

          child: IconButton(onPressed: ()async{
            NotificationControl control = NotificationControl();
            try{
              await control.deleteNotification(notification);
              await control.deleteFromDatabase(notification);
              notificationRep.allNotifications = await control.queryDatabase();
              notificationRep.notifications = notificationRep.allNotifications;

            }catch (e){
              debugPrint(e.toString());
              Fluttertoast.showToast(msg: 'Não foi possível excluir a mensagem');
            }

          }, icon: Icon(UniconsLine.trash, color: MainColors.red, size: 20)),
        )
      ],
    );
  }
}

//
// class NotificationCard extends StatefulWidget {
//   NotificationModel notification;
//   NotificationCard({super.key, required this.notification});
//
//   @override
//   State<NotificationCard> createState() => _NotificationCardState();
// }
//
// class _NotificationCardState extends State<NotificationCard> {
//   late NotificationModel notification;
//   late NotificationRepository notificationRep;
//   bool isDeleting = false;
//   bool onCopy = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     notification=widget.notification;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     notificationRep = Provider.of<NotificationRepository>(context, listen: true);
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//           color: MainColors.grey,
//           borderRadius: const BorderRadius.all(Radius.circular(10))
//       ),
//       child:Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text(notification.title, style: TextStyle(color: MainColors.orange, fontSize: 14,  fontWeight: FontWeight.bold)))]),
//           const SizedBox(height: 8),
//           Row(children: [Flexible(child: Text(notification.body,style: const TextStyle(fontSize: 12), textAlign: TextAlign.justify))]),
//           widget.notification.link.isEmpty?const SizedBox():
//           GestureDetector(
//               onLongPress: ()async{
//                 await Clipboard.setData(ClipboardData(text: widget.notification.link));
//                 setState(()=>onCopy=!onCopy);
//                 await Future.delayed(const Duration(milliseconds: 1500));
//                 setState(()=>onCopy=!onCopy);
//               },
//               onTap: ()async{
//                 try{
//                   await launchUrlString(widget.notification.link, mode: LaunchMode.externalApplication);
//                 }catch (e){
//                   Fluttertoast.showToast(msg: 'Não é possível abrir o link');
//                 }
//               }, child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               transitionBuilder: (child, animation)=>ScaleTransition(scale: animation,child: child),
//               child: onCopy? const Row(key: ValueKey("true"),children: [Flexible(child: Text("Copiado para área de transferência")), SizedBox(width: 8),Icon(Icons.done)]):Row(key: const ValueKey("false"),children: [const Icon(Icons.link), const SizedBox(width: 8),Flexible(child: Text(widget.notification.link))]))),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Início: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.initialDate.toDate())}', style: TextStyle(color: MainColors.black2, fontSize: 10,  fontWeight: FontWeight.bold)),
//                   Text('Término: ${DateFormat('dd/MM/yyyy HH:mm').format(notification.finalDate.toDate())}', style: TextStyle(color: MainColors.black2, fontSize: 10,  fontWeight: FontWeight.bold))
//                 ],
//               )),
//               IconButton(onPressed: (){
//
//               }, icon: Icon(UniconsLine.trash))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
//
