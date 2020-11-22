class Voice {
  int voiceID;
  String voiceName;
  String voiceUrl;
  int folderID;
  DateTime voiceCreateDate;

  Voice.withID(this.voiceID, this.folderID, this.voiceName,this.voiceUrl, this.voiceCreateDate);

  Voice(this.voiceName, this.voiceUrl, this.folderID, this.voiceCreateDate);

  Voice.justNameAndURL(this.voiceName, this.voiceUrl);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["voice_id"] = voiceID;
    map["voice_name"] = voiceName;
    map["voice_url"] = voiceUrl;
    map["folder_id"] = folderID;
    map["voice_create_date"] = voiceCreateDate.toString();
    return map;
  }

  Voice.fromMap(Map<String, dynamic> map) {
    this.voiceID = map['voice_id'];
    this.voiceName = map['voice_name'];
    this.voiceUrl = map['voice_url'];
    this.folderID = map['folder_id'];
    this.voiceCreateDate = DateTime.parse(map['voice_create_date']);
  }

  @override
  String toString() {
    return 'Voice{voice_id: $voiceID, voice_name: $voiceName, folder_id: $folderID, voice_create_date: $voiceCreateDate}';
  }
}
