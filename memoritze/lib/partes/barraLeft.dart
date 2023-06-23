import 'package:flutter/material.dart';
import 'package:memoritze/Pages/addClass.dart';
import 'package:memoritze/setting.dart';

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
              child: Text(
                'Memoritze',
                style: TextStyle(
                  color: mySetting.getColorText(),
                  fontSize: 24,
                ),
              ),
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
            onTap: () => print("se presiono 'mi clase'"),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClass()),
              )
            },
          ),
        ],
      ),
    );
  }
}
