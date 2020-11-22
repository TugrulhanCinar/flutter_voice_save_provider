import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_voice_save/models/folder_model.dart';
import 'package:flutter_voice_save/models/voice_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'db_basedart.dart';

class SqliteDbServices implements DBBase {
  static SqliteDbServices _sqliteDbServices;
  static Database _database;

  factory SqliteDbServices() {
    if (_sqliteDbServices == null) {
      _sqliteDbServices = SqliteDbServices._internal();
      return _sqliteDbServices;
    } else {
      return _sqliteDbServices;
    }
  }

  SqliteDbServices._internal();

  Future<Database> _getDataBase() async {
    if (_database == null) {
      _database = await _initialDataBase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initialDataBase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "voice_save.db");

    /*   ///create images Directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    await new Directory(appDocDir.path + "/images").create(recursive: true);*/
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir.toString());
    await new Directory(appDocDir.path + "/folders").create(recursive: true);

    ///************

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets/db", "voice_save.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    return await openDatabase(path, readOnly: false, version: 1);
  }

  @override
  Future<int> createFolder(Folder folder) async {
    var db = await _getDataBase();
    var result = await db.insert("folder", folder.toMap());
    return result;
  }

  @override
  Future<int> updateFolderName(int folderID, String newFolderName) async {
    var db = await _getDataBase();
    return await db.rawUpdate(
        'UPDATE  folder SET  folder_name = "$newFolderName" WHERE folder_id = $folderID');
  }

  @override
  Future<int> deleteFolder(int folderID) async {
    var db = await _getDataBase();
    int a =
        await db.rawDelete('DELETE FROM folder WHERE folder_id = $folderID');
    return a;
  }

  @override
  Future<List<Folder>> getAllFolder() async {
    var db = await _getDataBase();
    var folderMapList = await db.rawQuery(
        "SELECT * FROM folder  ORDER BY folder.folder_create_date DESC");

    var folderList = List<Folder>();
    for (Map map in folderMapList) {
      folderList.add(Folder.fromMap(map));
    }
    return folderList;
  }

  ///**********************************

  @override
  Future<int> createVoice(Voice voice) async {
    var db = await _getDataBase();
    return await db.insert("voice", voice.toMap());
  }

  @override
  Future<int> deleteVoice(int voiceID) async {
    var db = await _getDataBase();
    return await db.rawDelete('DELETE FROM voice WHERE voice_id = $voiceID');
  }

  @override
  Future<List<Voice>> getAllVoice() async {
    var db = await _getDataBase();
    var voiceMapList = await db
        .rawQuery("SELECT * FROM voice  ORDER BY voice.voice_create_date DESC");

    var voiceList = List<Voice>();
    for (Map map in voiceMapList) {
      voiceList.add(Voice.fromMap(map));
    }
    return voiceList;
  }

  @override
  Future<int> updateVoiceName(int voiceID, String newVoiceName) async {
    var db = await _getDataBase();
    return await db.rawUpdate(
        'UPDATE  voice SET  voice_name = "$newVoiceName" WHERE folder_id = $voiceID');
  }
}
