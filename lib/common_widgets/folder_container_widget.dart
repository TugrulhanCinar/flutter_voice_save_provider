import 'package:flutter/material.dart';
import 'package:flutter_voice_save/models/folder_model.dart';

class FolderContainer extends StatelessWidget {

  final EdgeInsetsGeometry margin;
  final Folder folder;

  FolderContainer({Key key, this.margin,@required this.folder, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 90,
          child: Container(
            margin: margin,
            // child: _centerTitle(context),
            decoration: _boxDecoration,
          ),
        ),
        Expanded(
          flex: 10,
          child: Text(
            folder.folderName,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  BoxDecoration get _boxDecoration => BoxDecoration(
        color: folder.folderColor,
        boxShadow: _boxShadow,
        borderRadius: _borderRadius,
      );

  List<BoxShadow> get _boxShadow => [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 3,
          blurRadius: 2,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ];

  BorderRadius get _borderRadius => BorderRadius.only(
      topLeft: _radius(30), bottomLeft: _radius(15), topRight: _radius(10));

  Radius _radius(double radius) => Radius.circular(radius);
}
