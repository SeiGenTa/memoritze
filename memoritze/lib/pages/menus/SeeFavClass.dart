import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/infClass/InfoMyClass.dart';
import 'package:memoritze/settings.dart';
import '../../observers/notificationMenu.dart';

class FavClass extends StatefulWidget {
  late final ObserverOnMenu observer;
  FavClass({super.key, required this.observer});

  @override
  State<FavClass> createState() => _FavClassState();
}

class _FavClassState extends State<FavClass> {
  Setting mySetting = Setting();

  late List<Map<String, dynamic>> myClassFav;
  bool isPrepared = false;

  ConnectionDataBase myData = ConnectionDataBase();

  void init() async {
    try {
      myClassFav = await myData.getClassFav();
      isPrepared = true;
    } on Error {
      print("Hemos tenido un error");
    }
  }

  @override
  void initState() {
    super.initState();
    widget.observer.onChanged.listen((event) {
      init();
    });
    init();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context)
        .size
        .width; //InfoMyClass(number: myDataBase[index]['ID'])
    TextStyle textStyle = TextStyle(color: mySetting.getColorText());
    // ignore: unnecessary_null_comparison
    if (!isPrepared) {
      return Center(
        child: Text(
          "Estamos cargando la informacion",
          style: textStyle,
        ),
      );
    }
    return (myClassFav.isEmpty)
        ? Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "¡Buenas noticias! \n Ahora puedes agregar tus clases a favoritos .\n Han incorporado la funcionalidad que estábamos esperando , así que puedes empezar a utilizarla de inmediato.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mySetting.getColorText(),
                  ),
                )
              ],
            ),
          )
        : GridView.builder(
            itemCount: myClassFav.length,
            itemBuilder: (context, index) {
              return myBook(index);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (deviceWidth / 100).floor(),
              mainAxisExtent: 150,
            ),
          );
  }

  Widget myBook(int index) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                InfoMyClass(number: myClassFav[index]['ID']),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(-1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
        myClassFav = await myData.getClassFav();
        setState(() {
          isPrepared = true;
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          border: null,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.amber,
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
                  color: Colors.amber,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              myClassFav[index]['Nombre'],
                              style: const TextStyle(
                                color: Colors.white,
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
