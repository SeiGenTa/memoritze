import 'package:flutter/material.dart';
import 'package:memoritze/pages/SeeMyClass.dart';
import 'package:memoritze/settings.dart';

class Configurate extends StatefulWidget {
  const Configurate({super.key});

  @override
  State<Configurate> createState() => _ConfigurateState();
}

class _ConfigurateState extends State<Configurate> {
  Setting setting = Setting();
  @override
  Widget build(BuildContext context) {
    print(setting.stateNight);
    late bool modeNight;
    if (setting.stateNight == 0) {
      modeNight = false;
    } else {
      modeNight = true;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: setting.getBackgroundColor(),
        appBar: AppBar(
          backgroundColor: setting.getColorDrawerSecundary(),
          title: Container(
            alignment: Alignment.topLeft,
            child: IconButton(
              iconSize: 50,
              color: setting.getColorText(),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SeeMyClass(prepared: true,)), (route) => false);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Container(
            constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width/3,
                maxWidth: MediaQuery.sizeOf(context).width,
                minHeight: MediaQuery.sizeOf(context).height,
                maxHeight: MediaQuery.sizeOf(context).height),
            child: ListView(
              children: [Switch(value: modeNight, onChanged: (bool newValue){
                  setState(() {
                    setting.setStateNight();
                    modeNight = !modeNight;
                    newValue = modeNight;
                  });
              } )],
            )),
      ),
    );
  }
}