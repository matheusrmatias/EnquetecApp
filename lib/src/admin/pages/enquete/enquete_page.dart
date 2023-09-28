import 'package:enquetec/src/admin/repositories/coordinator_repository.dart';
import 'package:enquetec/src/admin/repositories/enquete_admin_repository.dart';
import 'package:enquetec/src/admin/widgets/enquete_admin_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../themes/main.dart';
import '../../models/coordinator_model.dart';

class EnquetesAdminPage extends StatefulWidget {
  const EnquetesAdminPage({super.key});

  @override
  State<EnquetesAdminPage> createState() => _EnquetesAdminPageState();
}

class _EnquetesAdminPageState extends State<EnquetesAdminPage> {
  late Coordinator coordinator;
  late EnqueteAdminRepository enqueteRep;
  TextEditingController search = TextEditingController();

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    enqueteRep.cleanEnquete(listen: false);
  }

  @override
  Widget build(BuildContext context) {
    enqueteRep = Provider.of<EnqueteAdminRepository>(context);
    coordinator = Provider.of<CoordinatorRepository>(context).coordinator;
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('HISTÓRICO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: MainColors.black2,
        actions: [
          GestureDetector(onTap: (){
            showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (BuildContext context){
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: MainColors.black2,
                    borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: Text('Os resultados poderão ser vistos a partir da data final!', style: TextStyle(color: MainColors.white, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.justify,))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Text('OK', style: TextStyle(color: MainColors.orange, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.justify,),
                          )
                        ],
                      )

                    ],
                  ),
                )
              );
            });
          }, child: Container(margin: const EdgeInsets.only(right: 32),child: Icon(Icons.info_outline, color: MainColors.red)))
        ],
      ),
      body:Container(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: RefreshIndicator(
            onRefresh: ()async{
              await Future.delayed(const Duration(seconds: 2));
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  titleSpacing: 0,
                  leading: const SizedBox(),
                  leadingWidth: 0,
                  centerTitle: true,
                  floating: true,
                  backgroundColor: MainColors.black2,
                  title: Container(
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
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Pesquisar',
                                hintStyle: TextStyle(color: MainColors.primary, fontSize: 14),
                                icon: Icon(Icons.search, color: MainColors.primary)
                            ),
                            controller: search,
                            // onTapOutside: (e)=>FocusScope.of(context).unfocus(),
                            onChanged: _searchNotification,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                enqueteRep.enquetes.isEmpty? SliverList.list(children: [Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('Nenhuma enquete encontrada', style: TextStyle(color: MainColors.white, fontSize: 12)))])]):SliverList.builder(
                    itemCount: enqueteRep.enquetes.length,
                    itemBuilder: (ctx, index){
                      return EnqueteAdminCard(enquete: enqueteRep.enquetes[index]);
                    }
                )
              ],
            ),
          )
      ),
    );
  }

  Future<void> _searchNotification(String query)async{
    final suggetions = enqueteRep.allEnquetes.where((element){
      final discipline = element.discipline.toLowerCase();
      final course = element.course.toLowerCase();
      final finalDate = DateFormat('dd/MM/yyyy HH:mm').format(element.finalDate.toDate());
      final initialDate = DateFormat('dd/MM/yyyy HH:mm').format(element.initialDate.toDate());
      final input = query.toLowerCase();

      return discipline.contains(input) || course.contains(input) || finalDate.contains(input) || initialDate.contains(input);
    }).toList();
    suggetions.sort((a,b) => b.finalDate.compareTo(a.finalDate));
    enqueteRep.enquetes = suggetions;
  }
}
