import 'package:flutter/material.dart';
import 'package:memoritze/Settings.dart';
import 'package:memoritze/pages/Configuraciones.dart';
import 'package:memoritze/pages/SeeMyClass.dart';
import 'package:memoritze/pages/AddClass.dart';

class BarLeft extends StatelessWidget {
  late int myContext;
  BarLeft({super.key, required this.myContext});

  @override
  Widget build(BuildContext context) {
    Setting mySetting = Setting();

    return Drawer(
      backgroundColor: mySetting.getColorDrawerSecundary(),
      child: ListView(
        padding: EdgeInsets.zero,
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

          //!Inicio botones

          ListTile(
            selected: (myContext == 1) ? true : false,
            selectedColor: Colors.black38,
            title: Text(
              "Mis Clases",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () => {
              if (myContext == 1)
                Navigator.pop(context)
              else
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeMyClass(),
                  ),
                  (Route<dynamic> route) => false,
                )
            },
          ),
          ListTile(
            title: Text(
              "Agregar Clase",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () => {
              if (myContext == 2)
                Navigator.pop(context)
              else
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AddClass()),
                  (Route<dynamic> route) => false,
                )
            },
          ),
          ListTile(
            title: Text(
              "Configuraciones",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ConfigurablePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
