import 'package:flutter/material.dart';
import 'package:flutter_voice_save/extensions/context_extension.dart';
import 'package:flutter_voice_save/extensions/color_extension.dart';
import 'package:flutter_voice_save/models/folder_model.dart';

import 'package:flutter_voice_save/view_model/voice_save_view_model.dart';
import 'package:provider/provider.dart';

class AddFolderPage extends StatefulWidget {
  @override
  _AddFolderPageState createState() => _AddFolderPageState();
}

class _AddFolderPageState extends State<AddFolderPage> {
  final buttonText = "Oluştur";
  final labelText = "Dosya ismi";
  final appBarText = "Klasör Oluştur";
  final _scafoldKey = GlobalKey<ScaffoldState>();

  final _textEditingController = TextEditingController();
  List<Color> allFolderColor;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _folder = Provider.of<VoiceSaveViewModel>(context, listen: false);
    allFolderColor = Theme.of(context).colorScheme.allFolderColor;
    return Scaffold(
      key: _scafoldKey,
      appBar: _appBar,
      body: _columnBody(_folder),
    );
  }

  Widget _columnBody(VoiceSaveViewModel v) => Container(
        padding: context.paddingAllLowMedium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _textField,
            context.emptylowMediumValueWidget,
            _selectColorsWidget,
            context.emptylowMediumValueWidget,
            _createButton(v),
          ],
        ),
      );

  Widget _createButton(VoiceSaveViewModel v) => RaisedButton(
        color: Theme.of(context).colorScheme.info,
        onPressed: () {
          _createButtonOnTap(v);
        },
        child: _createButtonContainer,
      );

  Widget get _createButtonContainer => Container(
        width: context.width,
        alignment: Alignment.center,
        child: _createButtonContainerText,
      );

  Widget get _createButtonContainerText =>
      Text(buttonText, style: context.theme.textTheme.subtitle1);

  _createButtonOnTap(VoiceSaveViewModel v) async {
    String text =
        _textEditingController.text.replaceAll(new RegExp(r"\s+"), "");

    print(text);
    if (text.length < 11 && text.length > 0) {
      int i = await v.createFolder(
          Folder.justNameAndColor(text, allFolderColor[selectedIndex]));
      if (i > 0) {
        Navigator.pop(context);
      } else {
        _scafoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Dosya ismi mevcut"),
          backgroundColor: Colors.orange,
        ));
      }
    } else {
      _scafoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Hatalı dosya ismi"),
        backgroundColor: Colors.orange,
      ));
    }
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

  Widget get _selectColorsWidget => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: allFolderColor
          .asMap()
          .map((key, value) => MapEntry(
              key,
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = key;
                  });
                },
                child: Padding(
                  padding: context.paddingAllLowValue,
                  child: CircleAvatar(
                    child:
                        key == selectedIndex ? Icon(Icons.check) : Container(),
                    backgroundColor: value,
                  ),
                ),
              )))
          .values
          .toList());

  AppBar get _appBar => AppBar(title: Text(appBarText));
}
