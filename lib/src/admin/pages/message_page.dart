import 'package:enquetec/src/admin/controllers/messages_controller.dart';
import 'package:enquetec/src/admin/models/coordinator_model.dart';
import 'package:enquetec/src/admin/models/message_model.dart';
import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/message_repository.dart';
import 'package:enquetec/src/admin/widgets/message_card.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}


class _MessagePageState extends State<MessagePage> {
  TextEditingController search = TextEditingController();
  late MessageRepository messages;
  late List<Message> allMessages;
  late Coordinator coordinator;
  int intCount = 10;
  final scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollController);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    messages.cleanMessages(listen: false);
  }

  @override
  Widget build(BuildContext context) {
    allMessages = Provider.of<MessageRepository>(context).allMessages;
    messages = Provider.of<MessageRepository>(context);
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      body: Container(
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
                      onChanged: searchMessage,
                    ),
                  )),
                ],
              ),
            ),
            Expanded(child: RefreshIndicator(
              onRefresh: ()async{
                try{
                  MessageControl control = MessageControl();
                  await control.updateAllDatabase( await control.queryAllMessages(coordinator));
                  allMessages = await control.queryDatabase();
                  messages.allMessages = allMessages;
                  messages.messages = allMessages;
                  Fluttertoast.showToast(msg: 'Mensagens Atualizadas');
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não foi possível atualizar as mensagens.');
                }

              },
              color: MainColors.orange,
              child: messages.messages.isEmpty? ListView(physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),children: [Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('Nenhuma mensagem encontrada', style: TextStyle(color: MainColors.white, fontSize: 12)))])]):ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: intCount>messages.messages.length?messages.messages.length:intCount,
                itemBuilder: (context, index){
                  final message = messages.messages[index];
                  return MessageCard(message: message);
                },
              ),
            ))
          ],
        )
      ),
    );
  }

  searchMessage(String query) {
    final suggetions = allMessages.where((element){
      final text = element.text.toLowerCase();
      final name = element.name.toLowerCase();
      final type = element.type.toLowerCase();
      final date = DateFormat('dd/MM/yyyy HH:mm').format(element.date.toDate());
      final input = query.toLowerCase();

      return text.contains(input) || name.contains(input) || type.contains(input) || date.contains(input);
    }).toList();
    messages.messages = suggetions;
  }


  void _scrollController() {
    if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
      Fluttertoast.showToast(msg: "Mensagens Carregadas");
      if(intCount<messages.messages.length){
        if(intCount+10>messages.messages.length){
          setState(()=>intCount = messages.messages.length);
        }else{
          setState(()=>intCount+=10);
        }
      }
    }
  }
}
