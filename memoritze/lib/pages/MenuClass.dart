import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/observers/notificationMenu.dart';
import 'package:memoritze/pages/Configuraciones.dart';
import 'package:memoritze/pages/menus/SeeFavClass.dart';
import 'package:memoritze/pages/menus/SeeMyClass.dart';
import 'package:memoritze/settings.dart';
import 'package:file_picker/file_picker.dart';

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

  final ObserverOnMenu _observer = ObserverOnMenu();

  void subscribeToStream(Stream<String> stream) {
    stream.listen((data) => setState(() {
          state = 0;
        }));
  }

  bool charge = false;
  bool boolChangePage = false;
  bool disablePage = false;

  void initPage() async {
    if (!widget.prepared) {
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
      duration: const Duration(milliseconds: 300),
    );
    initPage();
  }

  void dispose() {
    animationController.dispose();
    _observer.dispose();
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
                        child: MyClass(
                          observer: _observer,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            MediaQuery.of(context).size.width -
                                animationOfMenu.value,
                            0.0),
                        child: FavClass(observer: _observer),
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
                          top: stateMore ? 5 : -150,
                          right: 5,
                          child: FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: mySetting.getColorMore(),
                                  border: Border.all(
                                      color: mySetting.getColorText(),
                                      width: 0.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
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
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          stateMore = false;
                                        });
                                        messageOfInformation(context);
                                      },
                                      child: Text(
                                        "Informacion",
                                        style: TextStyle(
                                            color: mySetting.getColorText()),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          stateMore = false;
                                        });
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                backgroundColor:
                                                    mySetting.getColorNavSup(),
                                                title: Text(
                                                  "Se esta cargando la informacion",
                                                  style: TextStyle(
                                                      color: mySetting
                                                          .getColorText()),
                                                ),
                                                content: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 70,
                                                          maxHeight: 70,
                                                          minHeight: 70),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ));
                                          },
                                        );
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['json'],
                                        );

                                        if (result == null) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          return;
                                        }

                                        File file = File(
                                            result.files.single.path as String);

                                        String textResponse = "";

                                        try {
                                          Map<String, dynamic> info = json
                                              .decode(file.readAsStringSync());
                                          textResponse = await connection
                                              .chargeNewInfo(info);
                                        } finally {
                                          // ignore: use_build_context_synchronously

                                          _observer.notify(textResponse);
                                        }
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cargar/Actualizar clase",
                                        style: TextStyle(
                                            color: mySetting.getColorText()),
                                      ))
                                ],
                              ),
                            ),
                          )),
                      if (disablePage)
                        Container(
                          color: Colors.black26,
                        ),
                    ],
                  );
                },
              ),
              bottomNavigationBar: MyBottomBar(),
            ),
    );
  }

//Informacion de cuando precionen el boton de "informacion"
  Future<dynamic> messageOfInformation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: mySetting.getColorNavSup(),
            content: const SingleChildScrollView(
              child: Text(
                '''
Estimados usuarios,

En primer lugar, permítanme expresar mi más sincero agradecimiento a cada uno de ustedes por utilizar nuestra aplicación. Como creador y desarrollador de esta plataforma, es un honor ver cómo mi trabajo es apreciado y utilizado por personas como ustedes.

Esta aplicación es el resultado de una ardua labor y dedicación de una sola persona: yo mismo. Desde el inicio de este proyecto, mi objetivo siempre fue proporcionar una herramienta intuitiva y eficiente para el estudio personal. Quería ofrecer a los estudiantes y usuarios en general una manera única de aprender y crecer académicamente, permitiéndoles crear sus propias preguntas y establecer el momento más adecuado para abordarlas.

Ver cómo cada uno de ustedes ha utilizado la aplicación para su propio crecimiento personal y desarrollo académico me llena de gratitud y satisfacción. Sus comentarios positivos y sugerencias constructivas han sido una fuente de inspiración para seguir mejorando y expandiendo la aplicación.

Es esencial recordar que esta aplicación no sería nada sin su valioso apoyo y confianza en mi trabajo. Cada vez que la utilizan y la integran en su rutina de estudio, me motivan a esforzarme aún más para hacerla aún mejor.

Como creador, es emocionante saber que mi aplicación está desempeñando un papel en su búsqueda del conocimiento y en su camino hacia el éxito. Mi objetivo siempre ha sido facilitar su proceso de aprendizaje y proporcionarles una experiencia enriquecedora y personalizada.

Por lo tanto, permítanme reiterar mi profundo agradecimiento por ser parte de esta comunidad de usuarios. Su apoyo y retroalimentación son invaluables y me impulsan a seguir trabajando arduamente para mejorar y enriquecer la aplicación con nuevas funcionalidades y características.

Siempre estoy abierto a sus ideas y sugerencias, así que no duden en compartir cualquier comentario que tengan para ayudarme a hacer de esta aplicación un recurso aún más valioso para todos ustedes.

Una vez más, gracias por ser parte de esta emocionante travesía educativa y por confiar en mi aplicación para impulsar su crecimiento académico. Espero que continúen disfrutando de la experiencia de aprender de manera personalizada y a su propio ritmo.
''',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

//AppBAR
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
          bottom: BorderSide(color: mySetting.getColorText(), width: 0.2)),
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

  //Diseño de la AppBarButton
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
                    minimumSize: const MaterialStatePropertyAll(Size(30, 30)),
                    iconSize: const MaterialStatePropertyAll(30),
                    shape: MaterialStatePropertyAll(CircleBorder(
                        side: BorderSide(
                            style: state == 0
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
