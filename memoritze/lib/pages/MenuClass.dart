import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/menus/CreateNewClass.dart';
import 'package:memoritze/pages/menus/Observ.dart';
import 'package:memoritze/pages/menus/SeeFavClass.dart';
import 'package:memoritze/pages/menus/SeeMyClass.dart';
import 'package:memoritze/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// ignore: must_be_immutable
class MenuInit extends StatefulWidget {
  late bool prepared;

  MenuInit({super.key, required this.prepared});

  @override
  State<MenuInit> createState() => MenuInitState();
}

class MenuInitState extends State<MenuInit> implements Observer {
  @override
  void notification() {
    // TODO: implement notification
  }

  ConnectionDataBase connection = ConnectionDataBase();
  Setting mySetting = Setting();
  final List<String> nameClass = ["Mis clases", "Favoritos"];

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static Duration durationAnimations = Duration(milliseconds: 300);

  late AnimationController controllerChangePage;

  int state = 0;

  List<Widget> myStates = [
    MyClass(),
    FavClass(),
  ];

  void subscribeToStream(Stream<String> stream) {
    stream.listen((data) => setState(() {
          state = 0;
        }));
  }

  bool charge = false;
  bool boolChangePage = false;

  void initPage() async {
    await connection.init();
    await mySetting.chargeSetting();
    setState(() {
      charge = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: !charge
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            )
          : Scaffold(
              backgroundColor: mySetting.getBackgroundColor(),
              appBar: AppBar(
                backgroundColor: mySetting.getColorDrawerSecondary(),
                title: Text(
                  nameClass[state],
                  style: TextStyle(color: mySetting.getColorText()),
                ),
              ),
              body: AnimatedOpacity(
                opacity: !boolChangePage ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: myStates[state],
              ),
              bottomNavigationBar: MyBottomBar(),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  CurvedNavigationBar MyBottomBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      color: mySetting.getColorDrawerSecondary(),
      backgroundColor: Color(0),
      height: kBottomNavigationBarHeight,
      items: [
        Icon(
          Icons.home,
          color: mySetting.getColorText(),
          size: 30,
        ),
        Icon(
          Icons.star,
          color: mySetting.getColorText(),
          size: 30,
        ),
      ],
      onTap: (value) => changePage(value),
    );
  }

  changePage(int value) async {
    setState(() {
      boolChangePage = true;
    });
    await Future.delayed(durationAnimations);
    setState(() {
      state = value;
      boolChangePage = false;
    });
  }
}
