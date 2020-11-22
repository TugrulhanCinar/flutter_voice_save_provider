import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice_save/extensions/context_extension.dart';
import 'package:flutter_voice_save/models/folder_model.dart';
import 'package:flutter_voice_save/models/voice_model.dart';
import 'package:flutter_voice_save/view_model/voice_save_view_model.dart';
import 'package:provider/provider.dart';

class AddVoicePage extends StatefulWidget {
  final Folder folder;

  const AddVoicePage({Key key, this.folder}) : super(key: key);

  @override
  _AddVoicePageState createState() => _AddVoicePageState();
}

class _AddVoicePageState extends State<AddVoicePage> {
  final labelText = "Dosya ismi";
  final saveFileText = "Kaydet";
  final noneSelectFieldButtonText = "Dosya Seçiniz";
  final selectedFieldButtonText = "Dosya Seçildi";
  FilePickerResult result;
  String voiceUrl;
  bool isFile = false;
  final _scafoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final voiceModel = Provider.of<VoiceSaveViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      key: _scafoldKey,
      body: _body(voiceModel),
    );
  }

  Widget _body(VoiceSaveViewModel voice) => Padding(
        padding: context.paddingAllLowMedium,
        child: _columnBody(voice),
      );

  Widget _columnBody(VoiceSaveViewModel voice) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _textField,
          _filePickerButton,
          _saveButton(voice),
        ],
      );

  Widget get _filePickerButton => Container(
        alignment: Alignment.bottomRight,
        child: RaisedButton(
          color: isFile ? Colors.green[700] : Colors.white54,
          child: _filePickerButtonText,
          onPressed: _filePickerButtonOnClick,
        ),
      );

  void _filePickerButtonOnClick() async {
    setState(() async {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        isFile = true;
      }
    });
  }

  Text get _filePickerButtonText {
    return Text(
      isFile ? selectedFieldButtonText : noneSelectFieldButtonText,
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(color: isFile ? Colors.white : Colors.black),
    );
  }

  Widget _saveButton(VoiceSaveViewModel voice) => SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () => _saveButtonOnClick(voice),
          child: _saveButtonText,
        ),
      );

  Text get _saveButtonText => Text(saveFileText);

  void _saveButtonOnClick(VoiceSaveViewModel voiceViewModel) async {
    String text = _textEditingController.text;
    int i;
    if (text.length < 11 && text.length > 0 && isFile) {
      i = await voiceViewModel.createVoice(
          Voice.justNameAndURL(text, result.files.single.path), widget.folder);

      if (i > 0) {
        Navigator.pop(context);
      } else {
        showSnackBar("Dosya ismi mevcut");
      }
    } else if (!isFile) {
      showSnackBar("Dosya seçilmedi");
    } else {
      showSnackBar("Hatalı dosya ismi");
    }
    clearCache();
  }

  void clearCache() {
    if (result != null) {
      File file = File(result.files.single.path);
      file.delete(recursive: true);
    }
  }

  showSnackBar(String text) {
    _scafoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.orange,
    ));
  }

  Widget get _textField => TextField(
        maxLength: 10,
        controller: _textEditingController,
        maxLengthEnforced: true,
        style: TextStyle(color: Colors.red),
        maxLines: 10,
        minLines: 1,
        decoration: _inputDecoration,
      );

  InputDecoration get _inputDecoration => InputDecoration(
        labelText: labelText,
        errorMaxLines: 10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      );
}
