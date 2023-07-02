import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConectioDataBase {
  bool initiated = false;

  Future<Database> connect() async {
    return await openDatabase(join(await getDatabasesPath(), 'memoritzeDB.db'));
  }

  void close(Database myDataBase) {
    myDataBase.close();
  }

  Future<void> init() async {
    Database database = await openDatabase(
        // Establece la ruta a la base de datos.
        join(await getDatabasesPath(), 'memoritzeDB.db'),
        // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar nuestra info
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE setting (
            NightMode INTEGER,
            Version INTEGER,
            Lenguaje TEXT
          );
        ''');
      // Ejecuta la sentencia CREATE TABLE en la base de datos
      await db.execute('''
          CREATE TABLE clase (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          cantMateria INTEGER,
          Nombre TEXT,
          Descripcion TEXT,
          FechPrio INTEGER
          );
          ''');

      await db.execute('''
          CREATE TABLE materia (
          ID INTEGER,
          ID_subclass INTEGER PRIMARY KEY AUTOINCREMENT,
          cantPreg INTEGER,
          Nombre TEXT,
          FechPrio INTEGER,
          FOREIGN KEY (ID) REFERENCES clase(ID)
          );
          ''');

      await db.execute('''
          CREATE TABLE pregunta (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          ID_class INTEGER,
          ID_subclass INTEGER,
          Pregunta TEXT,
          respuesta TEXT,
          eval INTEGER,
          FOREIGN KEY (ID_subclass) REFERENCES materia(ID_subclass)
          FOREIGN KEY (ID_class) REFERENCES clase(ID)
          );
          ''');

      print("se creo la base de datos");
    },
        // Establece la versión. Esto ejecuta la función onCreate y proporciona una
        // ruta para realizar actualizacones y defradaciones en la base de datos.
        version: 1);
    initiated = true;
    close(database);
  }

  Future<Map<String, dynamic>> getSetting() async {
    Database data = await connect();
    List<Map<String, dynamic>> inf = await data.query('setting');
    if (inf.length == 0) {
      data.insert(
          "setting", {'NightMode': 0, 'Version': 10, 'Lenguaje': "Esp"});
      close(data);
      return {'NightMode': 0, 'Version': 10, 'Lenguaje': "Esp"};
    }
    close(data);
    return inf[0];
  }

  Future<bool> changeSetting(
      int nightMode, int version, String language) async {
    Database data = await connect();
    data.update("setting",
        {'NightMode': nightMode, 'Version': version, 'Lenguaje': language});
    close(data);
    return true;
  }

  Future<bool> createClass(String name, String description) async {
    Database data = await connect();
    data.insert("clase", {
      "Nombre": name,
      "Descripcion": description,
      "FechPrio": DateTime.now().difference(DateTime(1970)).inSeconds,
      "cantMateria": 0,
    });
    close(data);
    return true;
  }

  Future<List<Map<String, dynamic>>> getClass(int id) async {
    Database data = await connect();
    late List<Map<String, dynamic>> info;
    if (id != -1) {
      info = await data.query('clase',
          where: 'ID = ${id.toString()}', orderBy: 'FechPrio DESC');
    } else {
      info = await data.query('clase', orderBy: 'FechPrio DESC');
    }

    close(data);
    return info;
  }
}
