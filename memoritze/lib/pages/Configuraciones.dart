import 'package:flutter/material.dart';
import 'package:memoritze/pages/SeeMyClass.dart';
import 'package:memoritze/settings.dart';

class ConfigurablePage extends StatefulWidget {
  const ConfigurablePage({super.key});

  @override
  State<ConfigurablePage> createState() => _ConfigurablePageState();
}

class _ConfigurablePageState extends State<ConfigurablePage> {
  Setting setting = Setting();
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: setting.getColorDrawerSecondary(),
          title: IconButton(
            iconSize: 50,
            color: setting.getColorText(),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeeMyClass(
                            prepared: true,
                          )),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: ListView(
                children: [
                  Text(
                    "Configuraciones",
                    style: TextStyle(
                        color: setting.getColorText(),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Divider(color: setting.getColorText()),
                  Text(
                    "Cambios visuales",
                    style: TextStyle(
                        color: setting.getColorText(),
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Switch(
                          value: modeNight,
                          onChanged: (bool newValue) {
                            setState(() {
                              setting.setStateNight();
                              modeNight = !modeNight;
                              newValue = modeNight;
                            });
                          }),
                      Text(
                        "Modo nocturna",
                        style: TextStyle(color: setting.getColorText()),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Switch(
                          value: false,
                          onChanged: (bool newValue) {
                            //setState(() {
                            //  setting.setStateNight();
                            //  modeNight = !modeNight;
                            //  newValue = modeNight;
                            //});
                          }),
                      Text(
                        "Temas personalizados (PRONTO)",
                        style: TextStyle(color: setting.getColorText()),
                      ),
                    ],
                  ),
                  Divider(color: setting.getColorText()),
                  Text(
                    "Ajustes a las clases (Proximamente)",
                    style: TextStyle(
                        color: setting.getColorText(),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
