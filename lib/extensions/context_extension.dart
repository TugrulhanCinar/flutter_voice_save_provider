import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.of(this).size.width * val;

  double dynamicHeight(double val) => MediaQuery.of(this).size.height * val;

  double get height =>  MediaQuery.of(this).size.height;


  double get width =>  MediaQuery.of(this).size.width;

  ThemeData get theme => Theme.of(this);
}

extension NumberExtension on BuildContext {
  double get lowValue => dynamicHeight(0.003);

  double get lowMediumValue => dynamicHeight(0.015);

  double get mediumValue => dynamicHeight(0.005);

  double get highValue => dynamicHeight(0.05);

}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingAllLowValue => EdgeInsets.all(lowValue);

  EdgeInsets get paddingAllLowMedium => EdgeInsets.all(lowMediumValue);

  EdgeInsets get paddingAllhigh => EdgeInsets.all(highValue);

  //EdgeInsets get paddingSymmetrichigh => EdgeInsets.symmetric(horizontal: highValue);

  EdgeInsets get titleTextPadding => EdgeInsets.only(left: lowMediumValue);
}

extension DividergExtension on BuildContext {

  Widget get customDivider => Divider(
        color: Colors.black,
        height: mediumValue,
      );
}



extension EmptyWidget on BuildContext {
  Widget get emptylowMediumValueWidget => SizedBox(
        height: lowMediumValue,
      );


  Widget get emptyMediumValueWidget => SizedBox(
    height: mediumValue,
  );
}
