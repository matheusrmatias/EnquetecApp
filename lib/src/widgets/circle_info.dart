import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';

class CircleInfo extends StatelessWidget {
  Color color = MainColors.orange;
  Color textColor;
  String title;
  String text;
  CircleInfo(this.color, {required this.title, required this.text,super.key, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      child: Column(
          children: [
            CircleAvatar(backgroundColor: color, child: Text(text.replaceAll(' ', ''), style: TextStyle(color: MainColors.white, fontSize: 12))),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.bold))
          ]
      ),
    );
  }
}
