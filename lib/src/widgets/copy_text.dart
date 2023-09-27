// ignore_for_file: must_be_immutable

import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyCard extends StatefulWidget {
  final String text;
  Widget ico;
  CopyCard({super.key, required this.text, this.ico = const Text('')});

  @override
  State<CopyCard> createState() => _CopyCardState();
}

class _CopyCardState extends State<CopyCard> {
  bool onCopy = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copyText,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: MainColors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          children: [
            widget.ico,
            Expanded(child: Container(margin: const EdgeInsets.only(left: 4),child: Text(onCopy? 'Copiado para área de transferência.':widget.text, style: const TextStyle(fontSize: 14)))),
            IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _copyText,
                icon: AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation)=>ScaleTransition(scale: animation, child: child),
                  child: onCopy? const Icon(Icons.done, key: ValueKey("true"),):const Icon(Icons.copy, key: ValueKey("false"))
                  ,))
          ],
        ),
      ),
    );
  }

  _copyText()async{
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(()=>onCopy=true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(()=>onCopy=false);

  }
}

//
// class CopyCard extends StatelessWidget {
//   final String text;
//   Widget ico;
//   CopyCard({super.key, required this.text, this.ico = const Text('')});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: MainColors.grey,
//         borderRadius: const BorderRadius.all(Radius.circular(8))
//       ),
//       child: Row(
//         children: [
//           ico,
//           Expanded(child: Container(margin: const EdgeInsets.only(left: 4),child: Text(text, style: const TextStyle(fontSize: 16),))),
//           IconButton(onPressed: ()async{
//             await Clipboard.setData(ClipboardData(text: text));
//
//             }, icon: const Icon(Icons.copy))
//         ],
//       ),
//     );
//   }
// }
