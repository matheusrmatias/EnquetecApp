import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'themes/main.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: MainColors.primary,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/splash.png',
                  width: 175,
                  height: 175,
                ),
                Padding(padding: const EdgeInsets.only(top: 196),child:  LoadingAnimationWidget.staggeredDotsWave(color: MainColors.white, size: 24))
              ],
            ),
          )
        )
    );
  }
}
