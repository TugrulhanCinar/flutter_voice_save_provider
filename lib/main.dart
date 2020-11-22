import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_voice_save/extensions/color_extension.dart';

import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'view_model/voice_save_view_model.dart';

//todo: arka planda kapanma olayını çöz
//todo voice olayını çöz

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<VoiceSaveViewModel>(create: (_) => VoiceSaveViewModel()),
      ],
      child: MyApp())));
}

class MyApp extends StatelessWidget {
  final String _title = "Save Audio";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: _themeDataLight(context),
      home: HomePage(),
    );
  }

  ThemeData _themeDataLight(BuildContext context) => ThemeData.light().copyWith(
        //scaffoldBackgroundColor: Theme.of(context).colorScheme.lila,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: _appBarTheme(context),
        textTheme: _textTheme,

      );

  AppBarTheme _appBarTheme(BuildContext context) => AppBarTheme().copyWith(
        color: Theme.of(context).colorScheme.customBlue,
      );

  TextTheme get _textTheme => TextTheme().copyWith(
        headline3: _headline3,
        bodyText1: _bodyText1,
        bodyText2: _bodyText2,
        caption: _caption,
      );

  TextStyle get _bodyText1 => TextStyle(
        fontSize: 18,
        color: Colors.white,
      );

  TextStyle get _headline3 => TextStyle(
    color: Colors.cyanAccent,
    fontSize: 24
  );

  TextStyle get _bodyText2 => TextStyle(
    color: Colors.blue,
  );

  TextStyle get _caption => TextStyle(
        fontSize: 18,
        color: Colors.white,
      );
}
