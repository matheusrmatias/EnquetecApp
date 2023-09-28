import 'package:enquetec/src/admin/controllers/notification_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/notification_repository.dart';
import 'package:enquetec/src/admin/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../themes/main.dart';

class NotificationAdminPage extends StatefulWidget {
  const NotificationAdminPage({super.key});

  @override
  State<NotificationAdminPage> createState() => _NotificationAdminPageState();
}

class _NotificationAdminPageState extends State<NotificationAdminPage> {
  late Coordinator coordinator;
  late NotificationRepository notificationsRep;
  TextEditingController search = TextEditingController();

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    notificationsRep.cleanNotifications(listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
    notificationsRep = Provider.of<NotificationRepository>(context,listen: true);
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('HISTÓRICO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: MainColors.black2,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: MainColors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child: Row(
                  children: [
                    Expanded(child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: TextField(
                        style: TextStyle(color: MainColors.primary, fontSize: 14),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Pesquisar',
                            hintStyle: TextStyle(color: MainColors.primary, fontSize: 14),
                            icon: Icon(Icons.search, color: MainColors.primary)
                        ),
                        controller: search,
                        onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                        onChanged: searchNotification,
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(child: RefreshIndicator(
                onRefresh: ()async{
                  NotificationControl control = NotificationControl();
                  notificationsRep.allNotifications = await control.queryAllNotifications(coordinator);
                  await control.updateAllDatabase(notificationsRep.allNotifications);
                  notificationsRep.notifications = notificationsRep.allNotifications;
                },
                color: MainColors.orange,
                child: notificationsRep.notifications.isEmpty? ListView(physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),children: [Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('Nenhum aviso encontrado', style: TextStyle(color: MainColors.white, fontSize: 12)))])]):ListView.builder(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: notificationsRep.notifications.length,
                  itemBuilder: (context, index)=>NotificationCard(notification: notificationsRep.notifications[index], key: widget.key),
                ),
              ))
            ],
          ),
        )
      ),
    );
  }
  searchNotification(String query){
    final suggetions = notificationsRep.allNotifications.where((element){
      final title = element.title.toLowerCase();
      final body = element.body.toLowerCase();
      final link = element.link.toLowerCase();
      final initialDate = DateFormat('dd/MM/yyyy HH:mm').format(element.initialDate.toDate());
      final finalDate = DateFormat('dd/MM/yyyy HH:mm').format(element.finalDate.toDate());
      final input = query.toLowerCase();

      return title.contains(input) || body.contains(input) || link.contains(input) || initialDate.contains(input) || finalDate.contains(input);
    }).toList();
    notificationsRep.notifications = suggetions;
  }
}
