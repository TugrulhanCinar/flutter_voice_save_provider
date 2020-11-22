
import 'package:flutter_voice_save/models/folder_model.dart';
import 'package:flutter_voice_save/models/voice_model.dart';

abstract class DBBase {
  Future<int> createVoice(Voice voice);

  Future<int> deleteVoice(int voiceID);

  Future<int> updateVoiceName(int voiceID, String newVoiceName);

  Future<List<Voice>> getAllVoice();

  ///***************************************

  Future<int> createFolder(Folder folder);

  Future<int> deleteFolder(int folderID);

  Future<int> updateFolderName(int folderID, String newFolderName);

  Future<List<Folder>> getAllFolder();

}
