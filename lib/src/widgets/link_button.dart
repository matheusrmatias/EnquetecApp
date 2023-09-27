import 'package:flutter/material.dart';

import '../themes/main.dart';

class LinkButton extends StatefulWidget {
  Function()? func;
  String text;
  LinkButton({super.key, required this.func, required this.text});

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.func,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: MainColors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
          child: Row(
            children: [
              Expanded(child: Text(
                  widget.text, style: const TextStyle(fontSize: 14))),
              IconButton(onPressed: null,
                  icon: Icon(Icons.arrow_forward_ios, color: MainColors.black,))
            ],
          ),
        )
    );
  }
}
