import 'dart:async';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';

class CustomAudioModel extends StatefulWidget {
  final String url;

  const CustomAudioModel({Key key, this.url}) : super(key: key);

  @override
  _CustomAudioModelState createState() => _CustomAudioModelState();
}

class _CustomAudioModelState extends State<CustomAudioModel> {
  AudioPlayer audioPlayer;
  Duration duration;
  Duration position;
  PlayerState playerState = PlayerState.isStopped;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  Widget build(BuildContext context) {
    return _listTileSubTitle;
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  Widget get _listTileSubTitle => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (duration != null) _timeWidgetAndSlider,
          _playAndStopButtonRow,
        ],
      );

  Widget get _timeWidgetAndSlider => Column(
        children: [
          _slider,
          _timeText,
        ],
      );

  Widget get _playAndStopButtonRow => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _playButton,
          _pauseButton,
          _stopButton,
        ],
      );

  Slider get _slider => Slider(
      value: position?.inMilliseconds?.toDouble() ?? 0.0,
      onChanged: (double value) {
        return audioPlayer.seek((value / 1000).roundToDouble());
      },
      min: 0.0,
      max: duration.inMilliseconds.toDouble());

  Widget get _timeText => Text(
        position != null
            ? "${positionText ?? ''} / ${durationText ?? ''}"
            : duration != null
                ? durationText
                : '',
        //style: TextStyle(fontSize: 24.0),
        style: Theme.of(context).textTheme.headline3,
      );

  Widget get _playButton => IconButton(
        icon: Icon(Icons.play_arrow),
        onPressed: isPlaying ? null : () => play(),
      );

  Widget get _stopButton => IconButton(
        icon: Icon(Icons.stop),
        onPressed: isPlaying || isPaused ? () => stop() : null,
      );

  Widget get _pauseButton => IconButton(
        icon: Icon(Icons.pause),
        onPressed: isPlaying ? () => pause() : null,
      );

  Future play() async {
    await audioPlayer.play(widget.url);
    setState(() {
      playerState = PlayerState.isPlaying;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.isPaused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.isStopped;
      position = Duration();
    });
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              position = p;
            }));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() {
          duration = audioPlayer.duration;
        });
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.isStopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  void onComplete() {
    setState(() {
      playerState = PlayerState.isStopped;
      position = Duration(seconds: 0);
    });
  }

  get isPlaying => playerState == PlayerState.isPlaying;

  get isPaused => playerState == PlayerState.isPaused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';
}
