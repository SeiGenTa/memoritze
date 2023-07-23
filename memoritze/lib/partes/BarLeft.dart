import 'package:flutter/material.dart';
import 'package:memoritze/settings.dart';
import 'package:memoritze/pages/Configuraciones.dart';

// ignore: must_be_immutable
class MyDrawerLeft extends StatefulWidget {
  const MyDrawerLeft({super.key});

  @override
  State<MyDrawerLeft> createState() => _MyDrawerLeftState();
}

class _MyDrawerLeftState extends State<MyDrawerLeft> {
  @override
  Widget build(BuildContext context) {
    Setting mySetting = Setting();

    return Drawer(
      backgroundColor: mySetting.getColorDrawerSecondary(),
      child: Column(
        children: <Widget>[
          //! TITULO SUPERIOR DEL DRAWER
          DrawerHeader(
            decoration: BoxDecoration(
              color: mySetting.getColorDrawer(),
            ),
            child: Center(
              child: Image.asset('assets/img/myIcon.png'),
            ),
          ),
          Expanded(child: Container()),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              "Configuraciones",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () async {
              await Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ConfigurablePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    }),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
