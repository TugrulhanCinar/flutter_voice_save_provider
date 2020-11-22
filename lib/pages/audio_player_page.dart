import 'package:flutter/material.dart';
import 'package:flutter_voice_save/common_widgets/custom_audio_model.dart';

class AudioPlayerPage extends StatefulWidget {
  final String title;
  final String url;
  final Color color;

  const AudioPlayerPage({Key key, this.title, this.url, this.color}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:  CustomAudioModel(
          url: widget.url,
        ),
      ),
    );
  }
}
