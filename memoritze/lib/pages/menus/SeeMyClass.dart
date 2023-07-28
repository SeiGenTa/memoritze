import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/InfoMyClass.dart';
import 'package:memoritze/pages/menus/CreateNewClass.dart';
import 'package:memoritze/settings.dart';

class MyClass extends StatefulWidget {
  const MyClass({super.key});

  @override
  State<MyClass> createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  int state = 0; // 0 normalState// 1 EditState

  //Info in delete State
  List<int> deleteIds = [];

  ConnectionDataBase myData = ConnectionDataBase();
  Setting mySetting = Setting();

  late List<Map<String, dynamic>> myDataBase;

  bool charge = false;

  void init() async {
    myDataBase = await myData.getClass(-1);
    print(myDataBase);
    setState(() {
      charge = true;
    });
    print(charge);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void addDelete(int id) {
    if (deleteIds.contains(id)) {
      deleteIds.remove(id);
      if (deleteIds.isEmpty) {
        setState(() {
          state = 0;
        });
      }
      setState(() {});
    } else {
      deleteIds.add(id);
      setState(() {
        state = 1;
      });
    }
  }

  void deleteClass() async {
    for (int i = 0; i < deleteIds.length; i++) {
      myData.deletedClass(deleteIds[i]);
    }
    deleteIds.clear;
    setState(() {
      init();
      state = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context)
        .size
        .width; //InfoMyClass(number: myDataBase[index]['ID'])
    return !charge
        ? const CircularProgressIndicator()
        : Stack(
            children: [
              GridView.builder(
                itemCount: myDataBase.length,
                itemBuilder: (context, index) {
                  return myBook(index);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (deviceWidth / 100).floor(),
                  mainAxisExtent: 150,
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: AnimatedCrossFade(
                    firstChild: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateClass()));
                        init();
                      },
                      style: ButtonStyle(
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.all(8)),
                        shape: const MaterialStatePropertyAll(CircleBorder()),
                        backgroundColor: MaterialStatePropertyAll(
                            mySetting.getColorsIconButton()),
                        iconColor: MaterialStatePropertyAll(Colors.white),
                        iconSize: const MaterialStatePropertyAll(40),
                      ),
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                    secondChild: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: mySetting.getBackgroundColor(),
                                titleTextStyle:
                                    TextStyle(color: mySetting.getColorText()),
                                title: const Text(
                                    "¿Estas seguro que quieres borrar estas clases?"),
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: mySetting.getColorText(),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        deleteClass();
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: mySetting.getColorText(),
                                      ))
                                ],
                              );
                            });
                      },
                      style: ButtonStyle(
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.all(8)),
                        shape: const MaterialStatePropertyAll(CircleBorder()),
                        backgroundColor: MaterialStatePropertyAll(
                            mySetting.getColorDrawerSecondary()),
                        iconColor:
                            MaterialStatePropertyAll(mySetting.getColorText()),
                        iconSize: const MaterialStatePropertyAll(40),
                      ),
                      child: const Icon(
                        Icons.delete,
                      ),
                    ),
                    crossFadeState: state == 0
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 200)),
              )
            ],
          );
  }

  Widget myBook(int index) {
    return GestureDetector(
      onLongPress: () {
        addDelete(myDataBase[index]['ID']);
      },
      onTap: () async {
        if (state == 0) {
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  InfoMyClass(number: myDataBase[index]['ID']),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(-1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeInOutBack;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
          myDataBase = await myData.getClass(-1);
          setState(() {
            charge = true;
          });
        } else if (state == 1) {
          addDelete(myDataBase[index]['ID']);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: deleteIds.contains(myDataBase[index]['ID'])
              ? Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255), width: 1)
              : null,
          color: deleteIds.contains(myDataBase[index]['ID'])
              ? mySetting.getColorDrawerSecondary()
              : const Color(0),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: mySetting.getColorBook().withOpacity(0.8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            Transform(
              transform: Matrix4.identity()..rotateY(1 / 14 * pi),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: mySetting.getColorPager().withOpacity(0.8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Transform(
                transform: (Matrix4.identity()
                  ..rotateY((2 / 5) * (1 / 2) * pi)),
                child: Card(
                  elevation: 5,
                  surfaceTintColor: Colors.blue,
                  color: mySetting.getColorBook(),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              myDataBase[index]['Nombre'],
                              style: TextStyle(
                                color: mySetting.getColorText(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Divider(
                              color: mySetting.getColorText(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
