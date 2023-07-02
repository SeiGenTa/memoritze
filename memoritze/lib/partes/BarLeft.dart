import 'package:flutter/material.dart';
import 'package:memoritze/Settings.dart';
import 'package:memoritze/pages/SeeMyClass.dart';
import 'package:memoritze/pages/AddClass.dart';

class BarraLeft extends StatelessWidget {
  const BarraLeft({super.key});

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
            title: Text(
              "Mis Clases",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () => {
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
              "Agregar clase",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AddClass()),
                (Route<dynamic> route) => false,
              )
            },
          ),
          ListTile(
            title: Text(
              "Light/Night Mode",
              style: TextStyle(
                color: mySetting.getColorText(),
                fontSize: 15,
              ),
            ),
            onTap: () {
              //mySetting.setStateNight();
              //Navigator.pushAndRemoveUntil(
              //  context,
              //  MaterialPageRoute(builder: (context) => MyClasses()),
              //  (Route<dynamic> route) => false,
              //);
            },
          ),
        ],
      ),
    );
  }
}
