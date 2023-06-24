import 'package:flutter/material.dart';
import 'package:memoritze/Pages/seeClass.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/partes/barraLeft.dart';
import 'package:memoritze/setting.dart';

class MyClasses extends StatefulWidget {
  const MyClasses({super.key});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  bool isLoading = true;

  MyDataBase myDataBase = MyDataBase();
  Setting mySetting = Setting();

  Future<void> seeMyClass() async {
    List<Map<String, dynamic>> result = await myDataBase.getClases();
    int lent = result.length;
    if (lent == 0) {
      myBody = Center(
        child: Text(
          "Parece ser que aun no tenemos clases juntos",
          style: TextStyle(
            color: mySetting.getColorText(),
            fontSize: 15,
          ),
        ),
      );
    } else {
      List<Widget> myCarts = [];
      for (int i = 0; i < lent; i++) {
        myCarts.add(const SizedBox(height: 15));
        myCarts.add(
          ElevatedButton(
            onPressed: () {
              print("Se entra al objeto ${result[i]['ID'].toString()}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeeClass(number: result[i]['ID'])));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    mySetting.getColorDrawerSecundary())),
            child: Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Nombre:",
                        style: TextStyle(
                          fontSize: 15,
                          color: mySetting.getColorText(),
                        ),
                      ),
                      Text(
                        result[i]['Nombre'].toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: mySetting.getColorText(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    "Description: ${result[i]['Descripcion']}",
                    style: TextStyle(color: mySetting.getColorText()),
                  )),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.settings)),
                  const SizedBox(width: 5),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.phonelink_erase_rounded))
                ],
              ),
            ),
          ),
        );
      }
      myBody = ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Column(
            children: myCarts,
          )
        ],
      );
    }

    setState(() {
      isLoading = false; // Indicar que la carga ha finalizado
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  late var myBody;

  @override
  void initState() {
    super.initState();
    seeMyClass();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: mySetting.getColorDrawer(),
          title: const Text('Mis Clases'),
        ),
        backgroundColor: mySetting.getBackgroundColor(),
        drawer: BarraLeft(),
        body: isLoading
            ? const Center(
                child: Text("Estamos trabajando para usted"),
              )
            : myBody,
      ),
    );
  }
}
