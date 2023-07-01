// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ConnectionDataBase {

  bool initiated = false;
  bool getInitiated() {
    return initiated;
  }

  Future<Database> connection() async {
    return await openDatabase(join(await getDatabasesPath(), 'memoritzeDB.db'));
  }

  Future<void> closeDatabase(dataBase) async {
    dataBase.close();
  }

  Future<void> init() async {
    initiated = true;
    Database dataBase =
        await openDatabase(join(await getDatabasesPath(), 'memoritzeDB.db'),
            onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE setting (
            NightMode INTEGER,
            Version INTEGER,
            Lenguaje TEXT
          );
        ''');

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
    }, version: 1);

    closeDatabase(dataBase);
  }

  //Configurate
  Future<Map<String, dynamic>> getSetting() async {
    Database myConnection = await connection();
    List<Map<String, dynamic>> setting = await myConnection.query("setting");
    if (setting.isEmpty) {
      myConnection.insert(
          "setting", {'NightMode': 0, 'Version': 10, 'Lenguaje': "español"});
      closeDatabase(myConnection);
      return {'NightMode': 0, 'Version': 10, 'Lenguaje': "español"};
    }
    closeDatabase(myConnection);
    return setting[0];
  }

  //updating
  void changeSetting(int newStateNight, int version, String language) async {
    Database connection = await this.connection();
    connection.update("setting",
        {'NightMode': newStateNight, 'Version': version, 'Lenguaje': language});
    closeDatabase(connection);
  }
}
