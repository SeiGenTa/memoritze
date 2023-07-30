import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/Configuraciones.dart';
import 'package:memoritze/pages/menus/SeeFavClass.dart';
import 'package:memoritze/pages/menus/SeeMyClass.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class MenuInit extends StatefulWidget {
  late bool prepared;

  MenuInit({super.key, required this.prepared});

  @override
  State<MenuInit> createState() => MenuInitState();
}

class MenuInitState extends State<MenuInit>
    with SingleTickerProviderStateMixin {
  ConnectionDataBase connection = ConnectionDataBase();
  Setting mySetting = Setting();
  final List<String> nameClass = ["Mis clases", "Favoritos"];

  late final AnimationController animationController;

  static Duration durationAnimations = const Duration(milliseconds: 300);

  int state = 0;

  bool stateMore = false;

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
    if (!widget.prepared) {
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
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    initPage();
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation animationOfMenu =
        Tween<double>(end: MediaQuery.of(context).size.width, begin: 0.0)
            .animate(animationController);

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
              appBar: appBarClass(),
              body: AnimatedBuilder(
                animation: animationOfMenu,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Transform.translate(
                        offset: Offset(-animationOfMenu.value, 0.0),
                        child: MyClass(),
                      ),
                      Transform.translate(
                        offset: Offset(
                            MediaQuery.of(context).size.width -
                                animationOfMenu.value,
                            0.0),
                        child: FavClass(),
                      ),
                      if (stateMore)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              stateMore = false;
                            });
                          },
                        ),
                      AnimatedPositioned(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          top: stateMore ? 5 : -50,
                          right: 5,
                          child: FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: mySetting.getColorMore(),
                                  border: Border.all(
                                      color: mySetting.getColorText(),
                                      width: 0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        await Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const ConfigurablePage(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              }),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        "Configuraciones",
                                        style: TextStyle(
                                            color: mySetting.getColorText()),
                                      ))
                                ],
                              ),
                            ),
                          )),
                    ],
                  );
                },
              ),
              bottomNavigationBar: MyBottomBar(),
            ),
    );
  }

  AppBar appBarClass() {
    return AppBar(
      iconTheme: IconThemeData(
        color: mySetting.getColorText(),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                stateMore = !stateMore;
              });
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ))
      ],
      backgroundColor: mySetting.getColorNavSup(),
      shape: BorderDirectional(
          bottom: BorderSide(color: mySetting.getColorText(), width: 0.4)),
      title: Row(
        children: [
          Image.asset(
            "assets/img/app_icon.png",
            height: kBottomNavigationBarHeight,
          ),
          const Text(
            "Memoritze",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MyBottomBar() {
    final Animation<double> curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    final Animation<double> animationButtons =
        Tween(begin: 0.0, end: 30.0).animate(curve);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: kBottomNavigationBarHeight,
      decoration: BoxDecoration(
        border: BorderDirectional(
            top: BorderSide(color: mySetting.getColorText(), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedBuilder(
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, -30 + animationButtons.value),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size(30, 30)),
                    iconSize: MaterialStatePropertyAll(30),
                    shape: MaterialStatePropertyAll(CircleBorder(
                        side: BorderSide(
                            style: state == 0
                                ? BorderStyle.solid
                                : BorderStyle.none,
                            color: mySetting.getColorText()))),
                    backgroundColor: MaterialStatePropertyAll(
                        mySetting.getBackgroundColor()),
                    elevation: MaterialStatePropertyAll(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.home,
                      color: mySetting.getColorText(),
                    ),
                  ),
                  onPressed: () {
                    animationController.reverse();
                    setState(() {
                      state = 0;
                      stateMore = false;
                    });
                  },
                ),
              );
            },
            animation: animationButtons,
          ),
          AnimatedBuilder(
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, -animationButtons.value),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: const MaterialStatePropertyAll(Size(30, 30)),
                    iconSize: const MaterialStatePropertyAll(30),
                    shape: MaterialStatePropertyAll(CircleBorder(
                        side: BorderSide(
                            style: state == 1
                                ? BorderStyle.solid
                                : BorderStyle.none,
                            color: mySetting.getColorText()))),
                    backgroundColor: MaterialStatePropertyAll(
                        mySetting.getBackgroundColor()),
                    elevation: const MaterialStatePropertyAll(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.star,
                      color: mySetting.getColorText(),
                    ),
                  ),
                  onPressed: () {
                    animationController.forward();
                    setState(() {
                      state = 1;
                      stateMore = false;
                    });
                  },
                ),
              );
            },
            animation: animationButtons,
          ),
        ],
      ),
    );
  }
}
