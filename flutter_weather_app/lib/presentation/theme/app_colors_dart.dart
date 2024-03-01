import 'package:flutter/material.dart';

class AppColors {
  Color get appColor => "#7633FF".toColor();

  Color get containerBgColor => "#F8F8F8".toColor();

  Color get brownColor => Colors.brown;



  Color get primary => Colors.black;

  Color get red => Colors.red;

  Color get whiteColor => Colors.white;

  Color get hintColor => Colors.grey.shade700;

  Color get splashLoader => Colors.green;


  Color get textFormFieldColor => Colors.grey.shade600;
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
