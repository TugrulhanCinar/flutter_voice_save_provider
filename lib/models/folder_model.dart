import 'package:flutter/material.dart';
import 'package:flutter_voice_save/models/voice_model.dart';

class Folder {
  int folderID;
  String folderName;
  String folderUrl;
  Color folderColor;
  DateTime folderCreateDate;
  List<Voice> voices = List();



  Folder(
      this.folderName, this.folderUrl, this.folderColor, this.folderCreateDate);
  Folder.justNameAndColor(
      this.folderName,this.folderColor
      );

  Folder.withID(this.folderID, this.folderName, this.folderColor,
      this.folderCreateDate);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["folder_id"] = folderID;
    map["folder_name"] = folderName;
    map["folder_url"] = folderUrl;
    map["folder_color"] = folderColor.value.toString();
    map["folder_create_date"] = folderCreateDate.toString();
    return map;
  }

  Folder.fromMap(Map<String, dynamic> map) {
    this.folderID = map["folder_id"];
    this.folderName = map["folder_name"];
    this.folderUrl = map["folder_url"];
    this.folderColor = Color(int.parse(map["folder_color"]));
    this.folderCreateDate = DateTime.parse(map["folder_create_date"]);
  }

  @override
  String toString() {
    return 'Folder{folderID: $folderID, folderName: $folderName, folderUrl: $folderUrl, folderColor: $folderColor, folderCreateDate: $folderCreateDate, voices: $voices}';
  }
}
