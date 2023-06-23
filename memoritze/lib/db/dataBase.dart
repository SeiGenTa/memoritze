import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDataBase {
  static final MyDataBase _instance = MyDataBase._internal();

  var initiated = false; //Esto indicara si esta iniciada

  bool getInitiated() {
    return initiated;
  }

  factory MyDataBase() {
    return _instance;
  }

  late Database _database;

  MyDataBase._internal();

  Future<void> init() async {
    Future<Database> database = openDatabase(
      // Establece la ruta a la base de datos.
      join(await getDatabasesPath(), 'memoritzeDB.db'),
      // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar nuestra info
      onCreate: (db, version) async {
        // Ejecuta la sentencia CREATE TABLE en la base de datos
        await db.execute('''
          CREATE TABLE clase (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          Nombre TEXT,
          Descripcion TEXT
          );
          ''');

        await db.execute('''
          CREATE TABLE materia (
          ID INTEGER,
          ID_subclass INTEGER PRIMARY KEY AUTOINCREMENT,
          Nombre TEXT,
          Descripcion TEXT,
          FOREIGN KEY (ID) REFERENCES clase(ID)
          );
          ''');

        await db.execute('''
          CREATE TABLE pregunta (
          ID_subclass INTEGER,
          PreguntaID INTEGER PRIMARY KEY AUTOINCREMENT,
          Pregunta TEXT,
          Descripcion TEXT,
          FOREIGN KEY (ID_subclass) REFERENCES materia(ID_subclass)
          );
          ''');

        print("se creo la base de datos");
      },
      // Establece la versión. Esto ejecuta la función onCreate y proporciona una
      // ruta para realizar actualizacones y defradaciones en la base de datos.
      version: 1,
    );

    _database = await database;
    initiated = true;
  }

  bool createClass(String name, String description) {
    if (!_database.isOpen) {
      return false;
    }
    _database.insert("clase", {"Nombre": name, "Descripcion": description});

    return true;
  }

  Future<List<Map<String, dynamic>>> getClases() async {
    return await _database.query('clase');
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }
}
