import 'package:flutter/material.dart';
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
        print(result[i]);
        myCarts.add(SizedBox(height: 15));
        myCarts.add(
          ElevatedButton(
            onPressed: () {},
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 10),
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
                        "${result[i]['Nombre'].toString()}",
                        style: TextStyle(
                          fontSize: 15,
                          color: mySetting.getColorText(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text("Descripcion: ${result[i]['Descripcion']}")),
                  IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                  SizedBox(width: 5),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.phonelink_erase_rounded))
                ],
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    mySetting.getColorDrawer())),
          ),
        );
      }
      myBody = ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
            ? Center(
                child: Text("Estamos trabajando para usted"),
              )
            : myBody,
      ),
    );
  }
}
