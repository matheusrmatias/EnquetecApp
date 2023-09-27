import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  Widget child;
  NavigationButton({super.key, required this.text, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=>Navigator.push(context, PageTransition(child: child,type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))),
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: MainColors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          children: [
            Expanded(child: Text(text ,style: const TextStyle(fontSize: 14))),
            IconButton(onPressed: null,icon: Icon(Icons.arrow_forward_ios, color: MainColors.black,))
          ],
        ),
      )
    );
  }
}
