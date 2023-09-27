import 'package:enquetec/src/repositories/setting_repository.dart';
import 'package:enquetec/src/widgets/setting_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../themes/main.dart';

class DisplaySettingPage extends StatefulWidget {
  const DisplaySettingPage({super.key});

  @override
  State<DisplaySettingPage> createState() => _DisplaySettingPageState();
}

class _DisplaySettingPageState extends State<DisplaySettingPage> {
  late SettingRepository prefs;
  _funcitonFt(bool e)async{
    prefs.imageDisplay = e;
  }

  @override
  Widget build(BuildContext context) {
    prefs = Provider.of<SettingRepository>(context, listen: true);
    
    return Scaffold(
      backgroundColor: MainColors.black2,
      appBar: AppBar(
        title: const Text('CONFIG. DE EXIBIÇÃO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: MainColors.primary,
        toolbarHeight: 60,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SettingSwitch(text: 'Foto de Perfil', onChange: _funcitonFt, value: prefs.imageDisplay,)
          ],
        ),
      ),
    );
  }
}
