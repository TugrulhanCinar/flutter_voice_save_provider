import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_voice_save/common_widgets/folder_container_widget.dart';
import 'package:flutter_voice_save/extensions/context_extension.dart';
import 'package:flutter_voice_save/models/folder_model.dart';
import 'package:flutter_voice_save/view_model/voice_save_view_model.dart';
import 'package:provider/provider.dart';
import 'add_folder_page.dart';
import 'voice_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Folder> folders = List();

  @override
  Widget build(BuildContext context) {
    final _voiceModel = Provider.of<VoiceSaveViewModel>(context);
    folders = _voiceModel.folders;
    return Scaffold(
      floatingActionButton: _floatingActionButton,
      appBar: _appBar,
      body: _voiceModel.state == VoiceSaveState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _gridViewBuilder,
    );
  }

  Widget get _appBar => AppBar(
        centerTitle: true,
        title: Text(
          "data",
        ),
      );

  Widget get _gridViewBuilder => GridView.builder(
        itemCount: folders.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return inkWellContainer(context, index);
        },
      );

  InkWell inkWellContainer(BuildContext context, int index) {
    return InkWell(
      onTap: () => inkWellContainerOnTap(index),
      onLongPress: () {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(100, 100, 100, 100),
          items: [
            PopupMenuItem<bool>(
              value: true,
              child: RaisedButton(
                onPressed: () async{
                  final _voiceModel = Provider.of<VoiceSaveViewModel>(context,listen: false);
                  await _voiceModel.removeFolder(folders[index]);
                  Navigator.pop(context);
                },
                child: Text("Sil"),
              ),
            ),
          ],
        );
      },
      child: _heroWidget(index),
    );
  }

  Widget _heroWidget(index) => Hero(
        tag: folders[index].folderName,
        child: _folderContainer(index),
      );

  inkWellContainerOnTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return VoiceListPage(
            title: index.toString(),
            color: folders[index].folderColor,
            // voices: folders[index].voices,
            folder: folders[index],
          );
        },
      ),
    );
  }

  Widget _folderContainer(int index) => FolderContainer(
        margin: context.paddingAllLowMedium,
        folder: folders[index],
      );

  FloatingActionButton get _floatingActionButton => FloatingActionButton(
        onPressed: _floatingActionButtonOnclick,
        child: _floatingActionButtonIcon,
      );

  Widget get _floatingActionButtonIcon => Icon(Icons.add_circle);

  _floatingActionButtonOnclick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddFolderPage()));
  }
}
