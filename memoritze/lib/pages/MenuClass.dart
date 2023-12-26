import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/parteMainPage/MessageError.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class MenuInit extends StatefulWidget {
  late bool prepared;

  MenuInit({super.key, required this.prepared});

  @override
  State<MenuInit> createState() => MenuInitState();
}

class MenuInitState extends State<MenuInit> with TickerProviderStateMixin {
  ConnectionDataBase db = ConnectionDataBase();
  Setting settings = Setting();

  // state = 0 (Initializing), = 1 (charged), =2 (error)
  int state = 0;
  late String infoStateError;

  int stateGesture = 0;

  void initializePage() async {
    await Future.delayed(const Duration(seconds: 1));

    late int charging;
    try {
      await db.init();
      await settings.chargeSetting();
      charging = 1;
    } catch (e) {
      infoStateError = e.toString();
      charging = 2;
    }
    setState(() {
      state = charging;
    });
  }

  void openOptions() {
    setState(() {
      stateGesture = 1;
    });
  }

  @override
  void initState() {
    if (!widget.prepared) initializePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: state == 0
          ? const Color.fromARGB(255, 18, 141, 22)
          : settings.getBackgroundColor(),
      body: AnimatedCrossFade(
          firstChild: SafeArea(
            child: Center(
              child: Image.asset(
                "assets/img/app_icon.png",
                height: kBottomNavigationBarHeight,
              ),
            ),
          ),
          secondChild: state == 2
              ? MessageError(messageError: infoStateError)
              : Stack(
                  children: [
                    Column(
                      children: [
                        //This the AppBar to the MainPage
                        AppBar(context),
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      settings.getColorNavSup(),
                                      Colors.white54
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 120,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(30),
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      "¿Seguimos donde lo dejamos?",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                    if (stateGesture != 0)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            stateGesture = 0;
                          });
                        },
                      ),
                    Positioned(
                      top: kToolbarHeight,
                      right: 10,
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(10),
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                            color: settings.getColorMore(),
                            borderRadius: BorderRadius.circular(20)),
                        height: stateGesture == 1 ? 125 : 0,
                        width: stateGesture == 1 ? 170 : 0,
                        child: const Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text(
                                "Configuraciones",
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.settings),
                              title: Text(
                                "Información",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          crossFadeState:
              state == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500)),
    );
  }

  Container AppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/img/app_icon.png",
                height: kBottomNavigationBarHeight - 10,
              ),
              Text(
                "Memoritze",
                style: TextStyle(color: settings.getColorText()),
              ),
            ],
          ),
          IconButton(
              onPressed: () => openOptions(),
              icon: Icon(
                Icons.more_vert_sharp,
                color: settings.getColorText(),
              )),
        ],
      ),
    );
  }
}
