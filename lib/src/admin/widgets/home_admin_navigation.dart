import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class HomeAdminNavigationBar extends StatefulWidget {
  List<HomeAdminNavigationBarItem> items;
  int currentIndex;
  Function(int e) onTap;
  HomeAdminNavigationBar({this.currentIndex = 0,super.key, required this.items, required this.onTap});

  @override
  State<HomeAdminNavigationBar> createState() => _HomeAdminNavigationBarState();
}

class _HomeAdminNavigationBarState extends State<HomeAdminNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: MainColors.black2,
      child: Row(
        children: listWidgetBuilder(),
      ),
    );
  }

  List<Widget> listWidgetBuilder(){
    List<Widget> items = [];
    int i = 0;
    for (var element in widget.items) {
      int index = i;
      items.add(
          Expanded(
            flex: widget.currentIndex==index?3:2,
            child: GestureDetector(
              onTap: (){
                widget.onTap(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                color: widget.currentIndex==index?MainColors.white2:MainColors.primary,
                height: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(element.icon, color: widget.currentIndex==index?MainColors.primary:MainColors.white),
                    if(widget.currentIndex==index) Text(element.text, style: TextStyle(color: MainColors.orange, fontWeight: FontWeight.bold, fontSize: 12))
                  ],
                ),
              ),
            ),
          )
      );
      i++;
    }
    return items;
  }
}

class HomeAdminNavigationBarItem{
  final IconData icon;
  final String text;
  HomeAdminNavigationBarItem({required this.icon, required this.text});
}