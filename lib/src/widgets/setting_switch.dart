import 'package:flutter/material.dart';

import '../themes/main.dart';

class SettingSwitch extends StatefulWidget {
  final String text;
  final onChange;
  bool value;
  SettingSwitch({super.key, required this.text, required this.onChange, required this.value});

  @override
  State<SettingSwitch> createState() => _SettingSwitchState();
}

class _SettingSwitchState extends State<SettingSwitch> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: MainColors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        children: [
          Expanded(child: Text(widget.text ,style: const TextStyle(fontSize: 16))),
          Switch(value: widget.value, onChanged: (e){
            widget.onChange(e);
            setState(()=>widget.value=e);
          }, activeColor: MainColors.orange)
        ],
      ),
    );
  }
}
