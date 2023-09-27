import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class HomeNavigationBar extends StatefulWidget {
  final Function(int e) ontap;
  int currentIndex;
  HomeNavigationBar({Key? key, required this.ontap, required this.currentIndex} ) : super(key: key);
  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  Color primary = MainColors.white2;
  Color secondary = MainColors.black2;
  Color textColor = MainColors.orange;
  
  @override
  Widget build(BuildContext context) {
    return Container(

      height: 60,
      child: Row(
        children: [
          Expanded(child: GestureDetector(
            onTap: (){
              widget.ontap(0);
              setState(()=>widget.currentIndex=0);
            },
            onHorizontalDragEnd: (details){
              print(details);
              if(details.velocity.pixelsPerSecond.dx>0){
                widget.ontap(1);
                setState(()=>widget.currentIndex=1);
              }
            },
            child: Container(color: widget.currentIndex==0?primary:secondary, height: double.maxFinite,child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Icon(UniconsLine.clipboard_notes, color: widget.currentIndex==0?textColor:primary),
              widget.currentIndex==1? SizedBox(): SizedBox(width: 8),
              widget.currentIndex==1? SizedBox(): Flexible(child: Text('ENQUETES', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)))
            ],),
            ),
          )
          ),
          Expanded(child: GestureDetector(
            onTap: (){
              widget.ontap(1);
              setState(()=>widget.currentIndex=1);
            },
            onHorizontalDragEnd: (details){
              print(details);
              if(details.velocity.pixelsPerSecond.dx<0){
                widget.ontap(0);
                setState(()=>widget.currentIndex=0);
              }
            },
            child: Container(color: widget.currentIndex==1?primary:secondary, height: double.maxFinite,child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Icon(Icons.person, color: widget.currentIndex==1?textColor:primary),

              widget.currentIndex==0? SizedBox(): const SizedBox(width: 8),
              widget.currentIndex==0? SizedBox(): Flexible(child: Text('CONTA', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)))
            ],),)

            ,))
        ],
      ),
    );
  }

  _style(){
    return TextStyle(
      color: textColor,
      fontSize: 16,
    );
  }
}
