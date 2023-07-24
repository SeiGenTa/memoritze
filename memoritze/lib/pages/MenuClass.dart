import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/menus/SeeFavClass.dart';
import 'package:memoritze/pages/menus/SeeMyClass.dart';
import 'package:memoritze/partes/BarLeft.dart';
import 'package:memoritze/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// ignore: must_be_immutable
class MenuInit extends StatefulWidget {
  late bool prepared;

  MenuInit({super.key, required this.prepared});

  @override
  State<MenuInit> createState() => MenuInitState();
}

class MenuInitState extends State<MenuInit> {
  ConnectionDataBase connection = ConnectionDataBase();
  Setting mySetting = Setting();
  final List<String> nameClass = ["Mis clases", "Favoritos"];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static Duration durationAnimations = const Duration(milliseconds: 300);

  int state = 0;

  List<Widget> myStates = [
    const MyClass(),
    const FavClass(),
  ];

  void subscribeToStream(Stream<String> stream) {
    stream.listen((data) => setState(() {
          state = 0;
        }));
  }

  bool charge = false;
  bool boolChangePage = false;

  void initPage() async {
    if (!widget.prepared){
    print("carga inicial");
    await connection.init();
    await mySetting.chargeSetting();
    }
    setState(() {
      charge = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  void dispose(){
    super.dispose();

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
              drawer: const MyDrawerLeft(),
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: mySetting.getColorText(),
                ),
                actions: [],
                backgroundColor: mySetting.getColorDrawerSecondary(),
                title: Text(
                  nameClass[state],
                  style: TextStyle(color: mySetting.getColorText()),
                ),
              ),
              body: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: !boolChangePage ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: myStates[state],
                  ),
                ],
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
      backgroundColor: const Color(0),
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
    if (value == state) return;
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

class Navigation {}
