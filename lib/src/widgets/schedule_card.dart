import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;
  const ScheduleCard({super.key, required this.schedule});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  Schedule schedule = Schedule();
  List<Widget> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schedule = widget.schedule;
    list.add(Row(children: [Expanded(child: Text(schedule.weekDay,style: TextStyle(fontSize: 14, color: MainColors.orange, fontWeight: FontWeight.bold)))]));
    for (var element in schedule.schedule) {
      list.add(
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(element[0],style: TextStyle(color: MainColors.black2, fontSize: 12, fontFamily: "Arial"), textAlign: TextAlign.justify),const SizedBox(width: 8),Expanded(child: Text(element[1],style: TextStyle(color: MainColors.black2, fontSize: 14),textAlign: TextAlign.end))]),
          )
      );
      list.add(Divider(color: MainColors.orange));
    }
  }

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
        children: list,
      ),
    );
  }
}
