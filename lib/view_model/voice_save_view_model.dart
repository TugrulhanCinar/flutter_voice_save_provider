import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_voice_save/models/folder_model.dart';
import 'package:flutter_voice_save/models/voice_model.dart';
import 'package:flutter_voice_save/services/sqlite_db_services.dart';
import 'package:path_provider/path_provider.dart';

enum VoiceSaveState { Idle, Busy }

class VoiceSaveViewModel with ChangeNotifier {
  VoiceSaveState _state = VoiceSaveState.Idle;
  final _repo = SqliteDbServices();
  List<Folder> folders = List();
  List<Voice> voices = List();

  VoiceSaveViewModel() {
    getAllFolder();
    getAllVoice();
  }

  VoiceSaveState get state => _state;

  set state(VoiceSaveState value) {
    _state = value;
    notifyListeners();
  }

  voiceInFolder() {
    for (Folder f in folders) {
      f.voices = List();
      for (Voice v in voices) {
        if (f.folderID == v.folderID) {
          f.voices.add(v);
        }
      }
    }
  }

  ///******************************************
  Future<List<Voice>> getAllVoice() async {
    state = VoiceSaveState.Busy;
    voices = await _repo.getAllVoice();
    state = VoiceSaveState.Idle;
    voiceInFolder();
    return voices;
  }

  Future<int> createVoice(Voice voice, Folder folder) async {
    state = VoiceSaveState.Busy;
    int id = -1;
    if (!_folderNameChechForVoice(voice.voiceName, folder)) {
      File _file = await File(voice.voiceUrl).copy(
          folder.folderUrl + "/" + voice.voiceName);
      var newVoice = Voice(
          voice.voiceName, _file.path, folder.folderID, DateTime.now());
      id = await _repo.createVoice(newVoice);
      newVoice.voiceID = id;
      voices.add(newVoice);
      addVoiceFolderList(folder, newVoice);
    }
    state = VoiceSaveState.Idle;
    return id;
  }

  void addVoiceFolderList(Folder folder, Voice voice) {
    folders[findFolderListIndex(folder.folderID)].voices.add(voice);
  }

  Future<int> deleteVoice(Voice voice) async {
    state = VoiceSaveState.Busy;
    var result = await _repo.deleteVoice(voice.voiceID);
    var file = File(voice.voiceUrl);
    try {
      file.delete();
    } catch (e) {
      throw e;
    }
    Folder f  = folders[findFolderListIndex(voice.folderID)];
    int voiceIndex = findVoiceFolderListIndex(f,voice);
    int folderIndex = findFolderListIndex(voice.folderID);
    folders[folderIndex].voices.removeAt(voiceIndex);
    state = VoiceSaveState.Idle;
    return result;
  }

  int findVoiceListIndex(int voiceID) {
    for (int i = 0; i < folders.length; i++) {
      if (folders[i].folderID == voiceID) {
        return i;

      }
    }
    return -1;
  }


  int findVoiceFolderListIndex(Folder folder, Voice voice) {
    // folder.voices.remove(voice);
    for (int i = 0; i < folder.voices.length; i++) {
      if (folder.voices[i].voiceID == voice.voiceID) {
        return i;
      }
    }
    return -1;
  }

/*  Future<int> updateVoiceName(int voiceID, String newVoiceName) async{
    state = VoiceSaveState.Busy;
    var result = await _repo.updateVoiceName(voiceID, newVoiceName);


    state = VoiceSaveState.Idle;
    return result;
  }*/

  folderNameChech(String voiceName, Folder folder) {
    if (folder.voices.length > 0) {
      for (Voice voice in folder.voices) {
        if (voice.voiceName == voiceName) {
          return true;
        }
      }
    }
    return false;
  }


  _folderNameChechForVoice(String voiceName, Folder folder) {
    if (folder.voices.length > 0) {
      for (Voice voice in folder.voices) {
        if (voice.voiceName == voiceName) {
          return true;
        }
      }
    }
    return false;
  }

  ///******************************************
  Future<List<Folder>> getAllFolder() async {
    state = VoiceSaveState.Busy;
    folders = await _repo.getAllFolder();
    voiceInFolder();
    state = VoiceSaveState.Idle;
    return folders;
  }

  Future<int> createFolder(Folder folder) async {
    if (!_folderNameChechForFolder(folder.folderName)) {
      state = VoiceSaveState.Busy;
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      var f = await Directory(appDocDir.path + "/folders/" + folder.folderName)
          .create(recursive: true);
      var url = f.path;
      var newFolder = Folder(
          folder.folderName, url, folder.folderColor, DateTime.now());
      newFolder.folderID = await _repo.createFolder(newFolder);
      folders.insert(0, newFolder);
      state = VoiceSaveState.Idle;
      return newFolder.folderID;
    } else {
      return -1;
    }
  }

   Future<int> removeFolder(Folder folder) async {
    state = VoiceSaveState.Busy;
    var result = await _repo.deleteFolder(folder.folderID);
    int index = findFolderListIndex(folder.folderID);
    folders.removeAt(index);
    var file = File(folder.folderUrl);
    try {
      file.delete(recursive: true);
    } catch (e) {
      throw e;
    }
    state = VoiceSaveState.Idle;
    return result;
  }

/*  Future<int> updateFolderName(int folderID, String newFolderName) async {
    state = VoiceSaveState.Busy;
    var f = await _repo.updateFolderName(folderID, newFolderName);
    folders[findFolderListIndex(folderID)].folderName = newFolderName;
    //todo dosya ismini değiştir:
    voiceInFolder();
    state = VoiceSaveState.Idle;
    return f;
  }*/

  int findFolderListIndex(int folderID) {
    for (int i = 0; i < folders.length; i++) {
      if (folders[i].folderID == folderID) {
        return i;

      }
    }
    return -1;
  }

  Folder findFolder(int folderID) {
    for (Folder f in folders) {
      if (f.folderID == folderID) {
        return f;
      }
    }
    return null;
  }

  _folderNameChechForFolder(String folderName) {
    if (folders.length > 0) {
      for (Folder folder in folders) {
        if (folder.folderName == folderName) {
          return true;
        }
      }
    }
    return false;
  }

///**********************************************
}