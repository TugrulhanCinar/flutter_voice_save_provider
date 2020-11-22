import 'package:flutter/material.dart';
import 'package:flutter_voice_save/extensions/context_extension.dart';
import 'package:flutter_voice_save/models/folder_model.dart';
import 'package:flutter_voice_save/pages/audio_player_page.dart';
import 'package:flutter_voice_save/view_model/voice_save_view_model.dart';
import 'package:provider/provider.dart';
import 'add_voice_page.dart';

class VoiceListPage extends StatefulWidget {
  final String title;
  final Color color;
  final Folder folder;

  VoiceListPage({
    Key key,
    this.title,
    this.color,
    this.folder,
  }) : super(key: key);

  @override
  _VoiceListPageState createState() => _VoiceListPageState();
}

class _VoiceListPageState extends State<VoiceListPage> {
  @override
  Widget build(BuildContext context) {
    final voiceModel = Provider.of<VoiceSaveViewModel>(context);
    return Hero(
      tag: widget.folder.folderName,
      child: Scaffold(
        appBar: _appBar,
        body: Container(child: _listViewSeperated(voiceModel)),
      ),
    );
  }

  Widget get _appBar => AppBar(
        title: Text(
          widget.folder.folderName,
        ),
        backgroundColor: widget.color,
        centerTitle: true,
        actions: _appBarActions,
      );

  List<Widget> get _appBarActions => [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: addVoiceAction,
        ),
      ];

  void addVoiceAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVoicePage(folder: widget.folder),
      ),
    );
  }

  Widget _listViewSeperated(VoiceSaveViewModel viewModel) => ListView.separated(
        itemCount: widget.folder.voices.length,
        separatorBuilder: (context, index) {
          return context.customDivider;
        },
        itemBuilder: (context, index) {
          return ListTile(
            title: _listTileText(index),
            trailing: _deleteButton(index, viewModel),
            onTap: () => _listTileOnClick(index),
          );
        },
      );

  Widget _listTileText(int index) => Text(
        widget.folder.voices[index].voiceName,
        style: _textStyle,
      );

  Widget _deleteButton(int index, VoiceSaveViewModel voiceViewModel) => IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red[800],
        ),
        onPressed: () {
          setState(() {

            voiceViewModel.deleteVoice(widget.folder.voices[index]);
          });
        },
      );

  void _listTileOnClick(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPlayerPage(
          title: widget.folder.voices[index].voiceName,
          url: widget.folder.voices[index].voiceUrl,
        ),
      ),
    );
  }

  TextStyle get _textStyle =>
      Theme.of(context).textTheme.bodyText2.copyWith(color: widget.color);
}
